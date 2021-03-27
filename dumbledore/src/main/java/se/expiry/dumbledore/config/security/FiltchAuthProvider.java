package se.expiry.dumbledore.config.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.*;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import se.expiry.dumbledore.dto.UserDTO;

import javax.servlet.http.HttpServletRequest;
import java.util.Objects;

@Component
public class FiltchAuthProvider {

    @Value("${filtch.uri}")
    private String FILTCH_URI;

    private static final String TOKEN_PREFIX = "Bearer ";

    private RestTemplate restTemplate;

    public FiltchAuthProvider(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public Authentication getAuthentication(String token){
        UserDTO authUser = filtchAuth(token);
        //TODO: Waz is dis?
//        authentication.setDetails(
//                new WebAuthenticationDetailsSource().buildDetails(request)
//        );
        return new UsernamePasswordAuthenticationToken(authUser, "", null);
    }

    public String resolveToken(HttpServletRequest request){
        String bearerToken = request.getHeader(HttpHeaders.AUTHORIZATION);

        if(!Objects.isNull(bearerToken) && bearerToken.startsWith(TOKEN_PREFIX))
            return bearerToken.substring(7, bearerToken.length());

        return null;
    }

    private UserDTO filtchAuth(String token){
        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.AUTHORIZATION, TOKEN_PREFIX + token);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<UserDTO> res =  restTemplate.exchange(FILTCH_URI, HttpMethod.GET, entity, UserDTO.class);
        if(res.getStatusCode().value() != 200){
            //TODO: Throw exc
            System.out.println("Nooo");
        }
        System.out.println("Siiii");
        return res.getBody();
    }

}
