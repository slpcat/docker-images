package	main
import (
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
	"crypto/hmac"
	"crypto/sha1"
	"encoding/base64"
	"time"
)

func getDate() string{
	//Wed, 16 May 2018 06:47:25 GMT
	now := time.Now()
	local1, _ := time.LoadLocation("GMT") //等同于"UTC"
	timeFormat := "Mon, 02 Jan 2006 03:04:05 GMT"
	return now.In(local1).Format(timeFormat)
	//fmt.Println(now.In(local1).Format(timeFormat))
}

 func hmacsha(date string,apikey string) string{
	//  date = "Fri, 03 Mar 2017 02:48:30 GMT"
	key := []byte(apikey)
	mac := hmac.New(sha1.New, key)
	mac.Write([]byte(date))
	value :=  mac.Sum(nil)
	//result := fmt.Printf("%s\n", base64.StdEncoding.EncodeToString(value))
	result := base64.StdEncoding.EncodeToString(value)
	return result
	//  fmt.Printf("%x\n", value)
	//  fmt.Printf(value) 
}

func authoriztion(accountName string,passwd string) string{
	//  passwd = "0szYYohzG8S5fSqANkQ8DlTYdCs="
	result := base64.StdEncoding.EncodeToString([]byte(accountName+":"+passwd))
	return result
}

 func httpDo(url string,header map[string]string,httpMethod string ,httpPostBody string) {
	client := &http.Client{}
	req, err := http.NewRequest( strings.ToUpper( httpMethod ), url,   
		strings.NewReader(httpPostBody))
	if err != nil {
		// handle error
	}
	for k, v := range header {
		req.Header.Set(k, v)		
	}
	resp, err := client.Do(req)
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		// handle error
	}
	fmt.Println(string(body))
}

func hmacsha1(date string,apikey string) string{
	key := []byte(apikey)
	mac := hmac.New(sha1.New, key)
	fmt.Printf("date byte: "+date)
	mac.Write([]byte(date))
	value :=  mac.Sum(nil)
	//  result := fmt.Printf("%s\n", base64.StdEncoding.EncodeToString(value))
	result := base64.StdEncoding.EncodeToString(value)
	return result
	//  fmt.Printf("%x\n", value)
	//  fmt.Printf(value)
}

func main() {
	userName := "example_username"
	apikey := "example_apiKey"
	httpHost := "https://open.chinanetcenter.com"
	httpUri := "/api/report/visitor/total/stream"

	date := getDate()
	passwd := hmacsha1(date,apikey)
	auth := authoriztion(userName,passwd)

	httpMethod := "POST"
	httpPostBody := "[{\"domain\":\"www.test.com\"}]"     //根据实际接口填入body
	/*  xml
	httpPostBody := "<?xml version="1.0" encoding="utf-8"?>
			<domain-list>
			<domain-name>www.example1.com</domain-name>
			<domain-name>www.example2.com</domain-name>
			</domain-list>"    //根据实际接口填入body
	*/
	//header
	header := map[string]string{
		"Content-Type": "application/json",
		"Accept": "application/json",
		"Date" : date,
		"Authorization" : "Basic "+ auth,
	}
	//get param
	httpGetParams := map[string]string{
		"datefrom": "2017-03-01T08:55:00+08:00",
		"dateto": "2017-03-01T09:14:59+08:00",
		"type" :"fiveminutes",
	}
	queryString := ""
	for k, v := range httpGetParams {
		if queryString != ""{
			queryString += "&"		
		}
		queryString += k +"="+url.QueryEscape(v)  //encode
		
	}

	fullUrlStr := httpHost+httpUri+"?"+queryString
	httpDo(fullUrlStr,header,httpMethod,httpPostBody)
}