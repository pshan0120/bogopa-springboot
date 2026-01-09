package boardgame;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ImportResource;

@SpringBootApplication
@ImportResource({
        "classpath:config/spring/context-*.xml",
        "file:src/main/webapp/WEB-INF/config/action-servlet.xml"
})
public class BogopaApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(BogopaApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(BogopaApplication.class, args);
    }
}
