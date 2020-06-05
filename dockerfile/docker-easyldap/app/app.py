#!/usr/bin/env python2.7
from pprint import pprint
from flask import Flask, render_template, request, redirect, session, url_for
import ldap
import os, hashlib
from ldap import modlist, schema

app = Flask(__name__)
ldap_server = "openldap.ktsee.com"

def make_secret(password):
    salt = os.urandom(4)
    sha = hashlib.sha1(password)
    sha.update(salt)
    digest_salt_b64 = '{}{}'.format(sha.digest(), salt).encode('base64').strip()
    tagged_digest_salt = '{{SSHA}}{}'.format(digest_salt_b64)
    return str(tagged_digest_salt)

def insert(dn, attrs) :
    password = session['password']
    user_dn = session['user_dn']
    base_dn = session['base_dn']
    connect = ldap.open(ldap_server)
    try :
        connect.bind_s(user_dn,password)
    except ldap.LDAPError:
        connect.unbind_s()
        result = {'error':True}
    ldif = modlist.addModlist(attrs)
    connect.add_s(dn, ldif)
    connect.unbind_s()

def search(search_filter=False) :
    password = session['password']
    user_dn = session['user_dn']
    base_dn = session['base_dn']
    connect = ldap.open(ldap_server)
    try:
        connect.bind_s(user_dn,password)
        result = connect.search_s(
                base_dn,
                ldap.SCOPE_SUBTREE,
                search_filter
                )
        connect.unbind_s()
    except ldap.LDAPError:
        connect.unbind_s()
        result = {'error':True}
    return result

def remove(dn) :
    password = session['password']
    user_dn = session['user_dn']
    base_dn = session['base_dn']
    connect = ldap.open(ldap_server)
    try:
        connect.bind_s(user_dn,password)
        result = connect.delete_s(dn)
        connect.unbind_s()
    except ldap.LDAPError:
        connect.unbind_s()
        result = {'error':True}
    return result


@app.before_request
def require_authorization():
    if 'base_dn' not in session and request.endpoint != 'login' and request.endpoint != 'static' and request.endpoint != 'recover' and request.endpoint != 'changepassword':
        return redirect(url_for('login'))

@app.route('/recover', methods=['POST'])
def recover() :
    email = request.form.get('email')
    return "Work in progress"

@app.route('/login', methods=['GET','POST'])
def login():
    if request.method == 'POST':
        base_dn = request.form.get('base_dn')
        username = request.form.get('username')
        password = request.form.get('password')
        user_dn = "cn=%s,%s" % (username, base_dn)
        connect = ldap.open(ldap_server)
        try:
            connect.bind_s(user_dn, password)
            connect.unbind_s()
            session['base_dn'] = base_dn
            session['password'] = password
            session['username'] = username
            session['user_dn'] = user_dn
            return redirect(url_for('index'))

        except ldap.LDAPError:
            connect.unbind_s()
            result = {'error':True}
            return redirect(url_for('login'))
    data = {'loggedin' : False}
    return render_template('login.html', data=data)

@app.route('/logout')
def logout() :
    session.pop('user_dn', None)
    session.pop('base_dn', None)
    session.pop('username', None)
    session.pop('password', None)
    return redirect(url_for('login'))

@app.route('/')
def index():
    groups = search(search_filter='objectClass=posixGroup')
    orgs = search(search_filter='objectClass=organizationalUnit')
    users = search(search_filter='objectClass=posixAccount')
    data = {
        'groups' : groups,
        'orgs' : orgs,
        'users' : users,
    }
    return render_template('userlist.html', data=data)

@app.route('/ous', methods=['GET','POST'])
def ous():

    data = search(search_filter='objectClass=organizationalUnit')
    base_dn = session['base_dn']

    if request.method == 'POST' :
        name = str(request.form.get('ou'))
        description = str(request.form.get('description'))
        dn = "ou=%s,%s" % (name, base_dn)
        attrs = {
                'ou' : str(name),
                'description' : description,
                'objectClass': [str('organizationalUnit'), str('top')]
                }
        insert(dn, attrs)
        return redirect(request.referrer or url_for('index'))

    return render_template('oulist.html', data=data)

@app.route('/groups', methods=['GET','POST'])
def groups():

    data = search(search_filter='objectClass=posixGroup')
    base_dn = session['base_dn']

    if request.method == 'POST' :
        name = str(request.form.get('cn'))
        description = str(request.form.get('description'))
        gid_num = str(request.form.get('gidNumber'))
        if not gid_num :
            gid_num = str(len(data)+500)
        attrs = {
                'cn' : name,
                'description' : description,
                'objectClass': ['posixGroup', 'top'],
                'gidNumber':gid_num,
                }
        dn = "cn=%s,%s" % (name, base_dn)
        insert(dn, attrs)
        return redirect(request.referrer or url_for('index'))

    return render_template('grouplist.html', data=data)

@app.route('/security', methods=['GET','POST'])
def security():

    data = search(search_filter='objectClass=simpleSecurityObject')
    base_dn = session['base_dn']

    if request.method == 'POST' :
        name = str(request.form.get('cn'))
        description = str(request.form.get('description'))
        password = str(make_secret(request.form.get('userPassword')))
        attrs = {
                'cn' : name,
                'description' : description,
                'objectClass': ['simpleSecurityObject', 'organizationalRole', 'top'],
                'userPassword': password
                }
        dn = "cn=%s,%s" % (name, base_dn)
        insert(dn, attrs)
        return redirect(request.referrer or url_for('index'))

    return render_template('security.html', data=data)


@app.route('/profile/')
def profile():
    data = search(str("cn=%s" % request.args.get('cn')))
    if not data :
        return redirect(url_for('index'))
    return render_template('profile.html', data=data)
    
@app.route('/changepassword/<uid>', methods=['GET','POST'])
def changepassword(uid=False):
    session['base_dn'] = 'dc=sumeils,dc=com'
    session['username'] = 'admin'
    session['password'] = 'sumei15b'
    session['user_dn'] = "cn=%s,%s" % (session['username'], session['base_dn'])
    
    data = search(str("uid=%s" % uid))
    
    if request.method == 'POST' :
        newpassword = str(make_secret(request.form.get("userPassword")))
        connect = ldap.open(ldap_server)

        try :
            connect.bind_s(session['user_dn'],session['password'])
        except ldap.LDAPError:
            connect.unbind_s()
            result = {'error':True}
            
        dn = "cn=%s,%s" % (data[0][1].get('cn')[0], session['base_dn'])
        ldif = [( ldap.MOD_REPLACE, 'userPassword', newpassword )]
        connect.modify_s(dn, ldif)
        connect.unbind_s()
	    
        session.pop('user_dn', None)
        session.pop('base_dn', None)
        session.pop('username', None)
        session.pop('password', None)
        return newpassword
    elif request.method == 'GET' :
        session.pop('user_dn', None)
        session.pop('base_dn', None)
        session.pop('username', None)
        session.pop('password', None)
        if not data :
            return 'no access'
        return render_template('changepassword.html', data=data)


@app.route('/delete/<cn>')
def deluser(cn=False):
    remove(cn)
    return redirect(request.referrer or url_for('index'))


@app.route('/update', methods=['POST'])
def update_profile() :
    form_data = request.form
    data = {}
    re = [data.update({k:form_data.get(k)}) for k in form_data if k]
    uid = str("%s%s" % (data.get('sn').lower(), data.get('givenName').lower()))
    full_name = "%s %s" % (data.get('givenName'), data.get('sn'))
    initials = str('.'.join([x[0] for x in full_name.split()])+".")
    data = {str(k):str(v) for k,v in data.iteritems() if v}
    user_num = len(search(search_filter='objectClass=posixAccount')) + 1000
    gid_num = str(request.form.get('gidNumber')) or "500"
    org_unit = str(request.form.get('orgUnit')) or "Users"
    data.pop('orgUnit', None)
    data.update({
        'loginShell':str("/bin/sh"),
        'userPassword':str(make_secret(data.get("userPassword"))),
        'uid':uid,
        'uidNumber':str(user_num),
        'gidNumber':gid_num,
        'initials':initials,
        'homeDirectory':str("/home/%s" % uid),
        'objectClass': [str('inetOrgPerson'), str('posixAccount'), str('top')]
    })

    dn = "cn=%s,ou=%s,%s" % (full_name, org_unit, session['base_dn'])
    insert(dn, data)
    return redirect(request.referrer or url_for('index'))


if __name__ == '__main__' :
    app.secret_key = 'YxYpMlAfLabFiJsGsHnebXGpsxrNme3yKLqWqoVmqiefeAsfYV3Pyjn7UjRwRtg'
    app.debug = True
    app.run(host="0.0.0.0", port=5000)

