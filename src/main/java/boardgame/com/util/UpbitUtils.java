package boardgame.com.util;

import java.net.InetAddress;
import java.util.*;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Whitelist;
import org.jsoup.select.Elements;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import boardgame.bo.dao.BoDao;

@Component("upbitUtils")
public class UpbitUtils {
	
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="boDAO")
	private BoDao boDAO;
	
	private String userAgent = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36";
	@SuppressWarnings("static-access")
	private Whitelist wl = new Whitelist().none();
	
	/* 포탈 수집 */
	public Map<String, Object> upbitPortal(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		StringBuffer resultMsg = new StringBuffer();
		Boolean result = false;
		String apiId = (String) map.get("apiId");
		
		if(StringUtils.equals("boardlife", apiId)) {
			resultMsg.append("[1] 보드라이프 수집 실행\n");
			
			String portalUrl = "http://www.boardlife.co.kr/game_rank.php?tb=&pg=";
			int runCnt = 0;
			for(int i=19; i<20; i++) {	// 20페이지까지 완료됨
				ChromeDriver driver = this.setChromeDriver(portalUrl + String.valueOf(i + 1));
				try {
					List<WebElement> el = driver.findElements(By.cssSelector("table > tbody > tr > td.game_row > table > tbody > tr > td.ellip > a"));
					/*for(int k=0; k<el.size(); k++) {
						WebElement elWe = el.get(k);
						log.debug(k + "번째 : " + elWe.getAttribute("href"));
						log.debug(k + "번째 : " + elWe.getText());
					}*/
					
					for(int j=0; j<el.size(); j++) {
						String url = el.get(j).getAttribute("href");
						log.debug(j + "번째 : " + url);
						Document subDoc = Jsoup.connect(url)
							.userAgent(userAgent)
							.timeout(30 * 1000)
							.header("Content-Type", "application/json; charset=UTF-8")
							.header("Accept", "application/json, text/plain")
							.header("Accept-Encoding", "gzip, deflate, br")
							.header("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7,es;q=0.6")
							.header("Content-Type", "application/json; charset=UTF-8")
							.header("Origin", "http://www.boardlife.co.kr")
							.header("Referer", "http://www.boardlife.co.kr/game_rank.php")
							.ignoreContentType(true)
							.post();
							
						Elements subEl = subDoc.select("td > table > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(2) > table > tbody > tr:nth-child(1) > td > h1");
						
						String gameNm = Jsoup.clean(subEl.get(0).toString(), wl).replaceAll(" : ", ": ");
						
						subEl = subDoc.select("td > table > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(2) > table > tbody > tr:nth-child(2) > td");
						String gameEngNm = Jsoup.clean(subEl.get(0).toString(), wl).replaceAll(" : ", ": ");
						
						subEl = subDoc.select("table > tbody > tr > td:nth-child(3) > table > tbody > tr:nth-child(1) > td:nth-child(1) > table > tbody > tr > td:nth-child(1) > table > tbody > tr > td:nth-child(4) > b > span");
						String gnrCd = "";
						if(subEl.size() > 0) {
							switch(Jsoup.clean(subEl.get(0).toString(), wl)){
								case "전략게임": 
									gnrCd = "S";
									break;
								case "추상게임": 
									gnrCd = "A";
									break;
								case "파티게임": 
									gnrCd = "P";
									break;
								case "가족게임": 
									gnrCd = "F";
									break;
								case "테마게임": 
									gnrCd = "T";
									break;
								case "어린이게임": 
									gnrCd = "C";
									break;
								case "워게임": 
									gnrCd = "W";
									break;
								default :
									gnrCd = "99";
							}
						} else {
							gnrCd = "99";
						}
						
						subEl = subDoc.select("table > tbody > tr > td:nth-child(3) > table > tbody > tr:nth-child(5) > td > table > tbody > tr > td:nth-child(1) > p");
						String plyrCnt[] = Jsoup.clean(subEl.get(0).toString(), wl).replaceAll("명", "").split("-");
						String minPlyrCnt = "";
						String maxPlyrCnt = "";
						if(plyrCnt.length == 1) {
							minPlyrCnt = plyrCnt[0];
							maxPlyrCnt = plyrCnt[0];
						} else if(plyrCnt.length > 1) {
							minPlyrCnt = plyrCnt[0];
							maxPlyrCnt = plyrCnt[1];
						} else {
							minPlyrCnt = "99";
							maxPlyrCnt = "99";
						}
						
						Map<String, Object> gameMap = new HashMap<String,Object>();
						gameMap.put("loginUserId", map.get("userId"));
						gameMap.put("gameNm", gameNm);
						gameMap.put("gameEngNm", gameEngNm);
						gameMap.put("gnrCd", gnrCd);
						gameMap.put("minPlyrCnt", minPlyrCnt);
						gameMap.put("maxPlyrCnt", maxPlyrCnt);
						gameMap.put("refUrl", url);
						
						if(StringUtils.equals("N", String.valueOf(boDAO.selectGameExistYn(gameMap).get("existYn")))) {
							boDAO.insertGame(gameMap);
							runCnt++;
						}
					}
				} catch (Exception e) {
					log.debug(e.getMessage());
				} finally {
					driver.quit();
				}
			}
			
			resultMsg.append("\n수집결과 : " + String.valueOf(runCnt) + " 건 등록");
			result = true;
		} else {
			resultMsg.append("[" + apiId + "] 미수집 포털\n");
		}
		
		resultMap.put("resultMsg", resultMsg.toString());
		resultMap.put("result", result);
		return resultMap;
	}
	
	// SSL 우회 등록
	/*public static void setSSL() throws NoSuchAlgorithmException, KeyManagementException {
		TrustManager[] trustAllCerts = new TrustManager[] {
			new X509TrustManager() {
				public X509Certificate[] getAcceptedIssuers() { return null; }
				public void checkClientTrusted(X509Certificate[] certs, String authType) {}
				public void checkServerTrusted(X509Certificate[] certs, String authType) {}
			}
		};
		SSLContext sc = SSLContext.getInstance("SSL");
		sc.init(null, trustAllCerts, new SecureRandom());
		HttpsURLConnection.setDefaultHostnameVerifier(
			new HostnameVerifier() {
				@Override
				public boolean verify(String hostname, SSLSession session) {
					return true;
				}
			}
		);
		HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
	}*/
	
	public Document setJsoupDocument(String url) throws Exception {
		return Jsoup.connect(url).userAgent(this.userAgent)
			.header("scheme", "https")
			.header("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
			.header("accept-encoding", "gzip, deflate, br")
			.header("accept-language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7,es;q=0.6")
			.header("cache-control", "no-cache")
			.header("pragma", "no-cache")
			.header("upgrade-insecure-requests", "1")
			.ignoreContentType(true)
			.timeout(10000).get();
	}
	
	public ChromeDriver setChromeDriver(String url) throws Exception {
		String chromeDriver = "";
		InetAddress ip = InetAddress.getLocalHost();
		//log.debug("ip.getHostName()" + ip.getHostName());
		//log.debug("ip.getHostAddress()" + ip.getHostAddress());
		if(StringUtils.equals(ip.getHostAddress(), "203.245.28.115")) {
			chromeDriver = "/usr/lib/chromium-browser/chromedriver";
		} else {
			chromeDriver = "C:\\borapi\\workspace\\borapi\\src\\main\\webapp\\resources\\win32\\chromedriver.exe";
			//chromeDriver = "/Users/scarlet/borapi/src/main/webapp/resources/win32/chromedriver";	// MAC 크롬드라이버
		}
		
		System.setProperty("webdriver.chrome.driver", chromeDriver);
		ChromeOptions options = new ChromeOptions();
		options.addArguments("--headless"); // 창 없는 옵션
		options.addArguments("--hide-scrollbars"); // 스크롤바 없애는 옵션
		options.addArguments("window-size=1920x1080"); // 화면 크기 옵션
		options.addArguments("disable-gpu"); // 성능
		options.addArguments("--no-sandbox ");
		ChromeDriver driver = new ChromeDriver(options);
		driver.manage().timeouts().implicitlyWait(2, TimeUnit.SECONDS);
		driver.get(url);
		return driver;
	}
}
