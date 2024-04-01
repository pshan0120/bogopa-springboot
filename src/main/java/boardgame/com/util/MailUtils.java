package boardgame.com.util;

import java.io.File;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.stereotype.Component;

import boardgame.com.service.ComService;

 
@Component("mailUtils")
public class MailUtils {
	
	@Resource(name = "comService")
	private ComService comService;
	
	Logger log = Logger.getLogger(this.getClass());
	
	private String host = "";
	private String username = "";
	private String password = "";
	private int port=25;
	
	public Map<String,Object> sendSimpleMail(Map<String,Object> map, HttpServletRequest request) throws Exception{
		Properties prop = new Properties();
		InputStream propInputStream = this.getClass().getClassLoader().getResourceAsStream("mail.properties");
		prop.load(propInputStream);
		username = (String) prop.get("username");
		host = (String) prop.get("host");
		StandardPBEStringEncryptor encryptor = new StandardPBEStringEncryptor();
		encryptor.setPassword("boardgame");
		password = encryptor.decrypt((String) prop.get("password"));
		String from = map.get("emailFrom").toString();
		String email = map.get("emailTo").toString();
		String title = map.get("title").toString();
		String content = map.get("cntnts").toString();
		//log.debug("password : " + password);
		/*log.debug("from : " + from);
		log.debug("email : " + email);
		log.debug("title : " + title);
		log.debug("content : " + content);*/
		
		if("".equals(from) || "".equals(email) || "".equals(title) || "".equals(content)) {
			log.debug("================= 일반메일 발송 실패 : 필수값 누락");
			return map;
		}
		
		String recipient = email;
		String subject = title;
		String body = content;

		Properties props = System.getProperties();
			
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", port);
		//props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.auth", "false");	// 인증 문제로 false 변경
		//props.put("mail.smtp.ssl.enable", "true");
		//props.put("mail.smtp.ssl.enable", "false");
		//props.put("mail.smtp.ssl.trust", host);
		
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		//session.setDebug(false); //for debug
		session.setDebug(true); //for debug

		Message msg = new MimeMessage(session);
		
		msg.setFrom(new InternetAddress(from));
		msg.addRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
		msg.setSubject(subject);
		msg.setSentDate(new Date());
		msg.setContent(body, "text/html;charset=" + "EUC-KR");

		Transport.send(msg);
		
		comService.insertEmailHis(map);
		
		return map;
	}
}
