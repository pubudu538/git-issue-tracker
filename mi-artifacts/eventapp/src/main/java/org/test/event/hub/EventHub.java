package org.test.event.hub;

import com.google.common.base.Strings;
import org.apache.http.HttpStatus;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.synapse.MessageContext;
import org.apache.synapse.mediators.AbstractMediator;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;


import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.simple.parser.ParseException;

public class EventHub extends AbstractMediator {

    private static final Log log = LogFactory.getLog(EventHub.class);
    private String statType;
    private String googleChatWebHook;
    private String issueCount;
    private final static String MONTH_TYPE = "MONTH";
    private final static String DAILY_TYPE = "DAILY";
    private final static String PRODUCT_APIM = "Product APIM";
    private final static String PRODUCT_APIM_REPO = "product-apim";

    public void setIssueCount(String newValue) {
        issueCount = newValue;
    }

    public String getIssueCount() {
        return issueCount;
    }

    public void setStatType(String newValue) {
        statType = newValue;
    }

    public String getStatType() {
        return statType;
    }

    public void setGoogleChatWebHook(String newValue) {
        googleChatWebHook = newValue;
    }

    public String getGoogleChatWebHook() {
        return googleChatWebHook;
    }

    public boolean mediate(MessageContext mc) {


        if (Strings.isNullOrEmpty(statType) || Strings.isNullOrEmpty(googleChatWebHook)) {
            log.error("Values are missing!!!");
            return false;
        }

        if (DAILY_TYPE.equals(statType.toUpperCase())) {

            sendDailyStats();
        }

        if (MONTH_TYPE.equals(statType.toUpperCase())) {

            sendMonthlyStats();
        }

        return true;
    }

    private void sendMonthlyStats() {

        String monthlyReport = "*Monthly Github Issue Summary: " + getMonthValue() + "*\n";

        try {
            Long allIssuesProductAPIM = getAllIssueCount(PRODUCT_APIM_REPO);
            Long monthlyIssueCreationProductAPIM = getIssueCreation(PRODUCT_APIM_REPO, getMonthPeriodValue());
            Long monthlyIssueClosureProductAPIM = getIssueClosure(PRODUCT_APIM_REPO, getMonthPeriodValue());

            monthlyReport = monthlyReport + constructMonthlyReport(PRODUCT_APIM,
                    monthlyIssueCreationProductAPIM.toString(), monthlyIssueClosureProductAPIM.toString(),
                    allIssuesProductAPIM.toString());

        } catch (ParseException e) {
            log.error("Error while getting the all the issue count - " + e.getLocalizedMessage());
        }

        sendChatNotification(getGoogleChatWebHook(), monthlyReport);
    }


    private void sendChatNotification(String url, String msg) {

        HttpPost post = new HttpPost(url);

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"text\":\"" + msg + "\"");
        json.append("}");

        try {
            post.setEntity(new StringEntity(json.toString()));
        } catch (UnsupportedEncodingException e) {
            log.error("Error while constructing the post request - " + e.getMessage());
        }

        try (CloseableHttpClient httpClient = HttpClients.createDefault();
             CloseableHttpResponse response = httpClient.execute(post)) {

            if (HttpStatus.SC_OK == response.getStatusLine().getStatusCode()) {
                log.info("Successfully sent the message to the Google Chat!");
            }

        } catch (IOException e) {
            log.error("Error while invoking the endpoint [URL] " + url);
            log.error(e.getMessage());
        }
    }

    private String constructMonthlyReport(String repo, String monthCreation, String monthClosure, String allIssues) {

        String repoReport = "*[" + repo + "]*\nOpen issues within the month - " +
                monthCreation + "\nClosed issues within the month - " +
                monthClosure + "\nTotal open issues - " + allIssues;

        return repoReport;
    }

    private void sendDailyStats() {

        String dailyReport = "*Monthly Github Issue Summary: " + getMonthValue() + "*\n";

        try {
            Long dailyIssueCreationProductAPIM = getIssueCreation(PRODUCT_APIM_REPO, getDayValue() + "..*");
            Long dailyIssueClosureProductAPIM = getIssueClosure(PRODUCT_APIM_REPO, getDayValue() + "..*");

            if (Long.parseLong(issueCount) <= dailyIssueCreationProductAPIM) {

                String msg = "*Alert:*\nToday (" + getDayValue() + ") *[" + PRODUCT_APIM + "]* issue count is high.\n" +
                        "Total open issue count today - *" + dailyIssueCreationProductAPIM + "*";

                sendChatNotification(getGoogleChatWebHook(), msg);

                log.info("Today " + getDayValue() + " issue count is high. Hence sent a message to Google Chat!");

            } else {
                log.info("[Daily] Open issue count " + dailyIssueCreationProductAPIM + " < " + issueCount +
                        ". Hence not sending any message!");
            }

            if (Long.parseLong(issueCount) <= dailyIssueClosureProductAPIM) {

                String msg = "*Congrats:*\nToday (" + getDayValue() + ") *[" + PRODUCT_APIM + "]* closed issue " +
                        "count is *" + dailyIssueClosureProductAPIM + "*.";

                sendChatNotification(getGoogleChatWebHook(), msg);

                log.info("Today " + getDayValue() + " closed issue count is " + dailyIssueClosureProductAPIM
                        + ". Hence sent a message to Google Chat!");

            } else {
                log.info("[Daily] Closed issue count " + dailyIssueClosureProductAPIM + " < " + issueCount +
                        ". Hence not sending any message!");
            }


        } catch (ParseException e) {
            log.error("Error while getting the all the issue count - " + e.getLocalizedMessage());
        }

    }


    private Long getAllIssueCount(String repo) throws ParseException {

        String endPoint = "https://api.github.com/search/issues?q=repo:wso2/" + repo + "+state:open";

        return getTotalCount(endPoint);
    }

    private Long getIssueCreation(String repo, String timePeriod) throws ParseException {

        String endPoint = "https://api.github.com/search/issues?q=repo:wso2/" + repo + "+created:" + timePeriod;

        return getTotalCount(endPoint);
    }


    private Long getIssueClosure(String repo, String timePeriod) throws ParseException {

        String endPoint = "https://api.github.com/search/issues?q=repo:wso2/" + repo + "+closed:" + timePeriod;

        return getTotalCount(endPoint);
    }

    private Long getTotalCount(String endPoint) throws ParseException {

        Map<String, String> headers = new HashMap<String, String>();
        headers.put("Accept", "application/vnd.github.v3+json");

        String result = getResponse(endPoint, headers);
        JSONParser parse = new JSONParser();
        JSONObject jobj = (JSONObject) parse.parse(result);
        Long totalCount = (Long) jobj.get("total_count");

        return totalCount;
    }

    private String getDayValue() {

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        Calendar calendar_start = getCalendarForNow();
        formatter.setTimeZone(calendar_start.getTimeZone());
        String dayValue = formatter.format(calendar_start.getTime());

        return dayValue;
    }


    private String getMonthPeriodValue() {

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        Calendar calendar_start = getCalendarForNow();
        calendar_start.set(Calendar.DAY_OF_MONTH, calendar_start.getActualMinimum(Calendar.DAY_OF_MONTH));
        formatter.setTimeZone(calendar_start.getTimeZone());
        String monthStart = formatter.format(calendar_start.getTime());

        Calendar calendar_end = getCalendarForNow();
        calendar_end.set(Calendar.DAY_OF_MONTH, calendar_end.getActualMaximum(Calendar.DAY_OF_MONTH));
        formatter.setTimeZone(calendar_end.getTimeZone());
        String monthEnd = formatter.format(calendar_end.getTime());

        return monthStart + ".." + monthEnd;
    }

    private String getMonthValue() {

        SimpleDateFormat formatter = new SimpleDateFormat("MMM-yyyy");

        Calendar calendar_start = getCalendarForNow();
        formatter.setTimeZone(calendar_start.getTimeZone());
        String month = formatter.format(calendar_start.getTime());

        return month;
    }

    private Calendar getCalendarForNow() {

        Calendar calendar = GregorianCalendar.getInstance();
        calendar.setTime(new Date());
        return calendar;
    }


    private String getResponse(String url, Map<String, String> requestHeaders) {

        String result = null;
        HttpGet request = new HttpGet(url);

        for (Map.Entry<String, String> entry : requestHeaders.entrySet()) {
            request.addHeader(entry.getKey(), entry.getValue());
        }

        try (CloseableHttpClient httpClient = HttpClients.createDefault();
             CloseableHttpResponse response = httpClient.execute(request)) {

            HttpEntity entity = response.getEntity();
            if (entity != null) {
                // return it as a String
                result = EntityUtils.toString(entity);
                return result;
            }

        } catch (IOException e) {
            log.error("Error while invoking the endpoint [URL] " + url);
            log.error(e.getMessage());
        } catch (Exception e) {
            log.error("Error while getting the response for the endpoint [URL] " + url);
            log.error(e.getMessage());
        }

        return result;
    }
}