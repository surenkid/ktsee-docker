package controllers

import (
	"math"
	"github.com/astaxie/beego"
	"github.com/lifei6671/mindoc/models"
	"github.com/lifei6671/mindoc/utils/pagination"
	"github.com/lifei6671/mindoc/conf"
	"net/url"
)

type HomeController struct {
	BaseController
}

func (c *HomeController) Prepare() {
	c.BaseController.Prepare()
	//如果没有开启匿名访问，则跳转到登录页面
	if !c.EnableAnonymous && c.Member == nil {
		c.Redirect(conf.URLFor("AccountController.Login")+"?url="+url.PathEscape(conf.BaseUrl+c.Ctx.Request.URL.RequestURI()), 302)
	}
}

func (c *HomeController) Index() {
	c.Prepare()
	c.TplName = "home/index.tpl"

	pageIndex, _ := c.GetInt("page", 1)
	pageSize := 18

	memberId := 0

	if c.Member != nil {
		memberId = c.Member.MemberId
	}
	books, totalCount, err := models.NewBook().FindForHomeToPager(pageIndex, pageSize, memberId)

	if err != nil {
		beego.Error(err)
		c.Abort("500")
	}
	if totalCount > 0 {
		pager := pagination.NewPagination(c.Ctx.Request, totalCount, pageSize, c.BaseUrl())
		c.Data["PageHtml"] = pager.HtmlPages()
	} else {
		c.Data["PageHtml"] = ""
	}
	c.Data["TotalPages"] = int(math.Ceil(float64(totalCount) / float64(pageSize)))

	c.Data["Lists"] = books
}
