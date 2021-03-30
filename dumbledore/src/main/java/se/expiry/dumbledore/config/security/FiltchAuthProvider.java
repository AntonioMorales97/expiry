package se.expiry.dumbledore.config.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.*;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.Role;
import se.expiry.dumbledore.dto.UserDTO;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Component
public class FiltchAuthProvider {

    @Value("${filtch.uri}")
    private String FILTCH_URI;

    private static final String TOKEN_PREFIX = "Bearer ";

    private RestTemplate restTemplate;

    public FiltchAuthProvider(RestTemplateBuilder restTemplateBuilder) {
        this.restTemplate = restTemplateBuilder.build();
    }

    public Authentication getAuthentication(String token){
        UserDTO authUser = filtchAuth(token);
        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        if(!authUser.getRoles().isEmpty()) {
            addAuthorities(authorities, authUser.getRoles());
        }


        return new UsernamePasswordAuthenticationToken(authUser, "", authorities);
    }

    public String resolveToken(HttpServletRequest request){
        String bearerToken = request.getHeader(HttpHeaders.AUTHORIZATION);

        if(!Objects.isNull(bearerToken) && bearerToken.startsWith(TOKEN_PREFIX))
            return bearerToken.substring(7, bearerToken.length());

        return null;
    }
    private  List<SimpleGrantedAuthority> addAuthorities(List<SimpleGrantedAuthority> authorities, List<Role> roles){
        roles.forEach(role ->{
            authorities.add(new SimpleGrantedAuthority("ROLE_"+role.getName()));
        });
        return authorities;
    }
    private UserDTO filtchAuth(String token){
        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.AUTHORIZATION, TOKEN_PREFIX + token);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<UserDTO> res =  restTemplate.exchange(FILTCH_URI, HttpMethod.GET, entity, UserDTO.class);
        if(res.getStatusCode().value() != 200){
            ExceptionDetail exceptionDetail = new ExceptionDetail(403, "Token invalid!");
            throw new ExpiryException(exceptionDetail);
        }
        return res.getBody();
    }

}
