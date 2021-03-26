package se.expiry.dumbledore.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.filter.OncePerRequestFilter;
import se.expiry.dumbledore.dto.UserDTO;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Configuration
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    private FiltchJwtFilter filtchJwtFilter;

    public WebSecurityConfig(RestTemplateBuilder restTemplateBuilder){
        this.filtchJwtFilter = new FiltchJwtFilter(restTemplateBuilder.build());
    }

    /**
     * Layer below WebSecurity. Sets up security against the API and adds filters.
     *
     * @param http The <code>HttpSecurity</code> to configure.
     *
     **/

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable().authorizeRequests().antMatchers("/*").permitAll();

        // Add JWT token filter
        http.addFilterBefore(
                filtchJwtFilter,
                UsernamePasswordAuthenticationFilter.class
        );
    }

    public static class FiltchJwtFilter extends OncePerRequestFilter {

        @Value("${filtch.uri}")
        private String FILTCH_URI;

        private RestTemplate restTemplate;

        public FiltchJwtFilter (RestTemplate restTemplate){
            this.restTemplate = restTemplate;
        }

        @Override
        protected void doFilterInternal(HttpServletRequest request,
                                        HttpServletResponse response,
                                        FilterChain chain)
                throws ServletException, IOException {
            // Get authorization header and validate
            final String header = request.getHeader(HttpHeaders.AUTHORIZATION);
            if (header.isEmpty() || !header.startsWith("Bearer ")) {
                chain.doFilter(request, response);
                return;
            }

            // Get jwt token and validate
            final String token = header.split(" ")[1].trim();
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", header);
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<UserDTO> res =  restTemplate.exchange(FILTCH_URI, HttpMethod.GET, entity, UserDTO.class);

            if(res.getStatusCodeValue() != 200){
                System.out.println("Invalid");
                //TODO: Error handling
            }
            System.out.println(res.getBody());
            UsernamePasswordAuthenticationToken
                    authentication = new UsernamePasswordAuthenticationToken(
                    res.getBody(), null,
                   null
            );

            authentication.setDetails(
                    new WebAuthenticationDetailsSource().buildDetails(request)
            );

            SecurityContextHolder.getContext().setAuthentication(authentication);
            chain.doFilter(request, response);
        }
    }
}
