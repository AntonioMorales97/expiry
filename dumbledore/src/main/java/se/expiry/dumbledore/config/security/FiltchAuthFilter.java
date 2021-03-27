package se.expiry.dumbledore.config.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Objects;

public class FiltchAuthFilter extends OncePerRequestFilter {

    FiltchAuthProvider filtchAuthProvider;

    public FiltchAuthFilter(FiltchAuthProvider filtchAuthProvider){
        this.filtchAuthProvider = filtchAuthProvider;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain)
            throws ServletException, IOException {

        String token = filtchAuthProvider.resolveToken(request);

        if(!Objects.isNull(token)){
            Authentication authentication = filtchAuthProvider.getAuthentication(token);

            if(!Objects.isNull(authentication))
                SecurityContextHolder.getContext().setAuthentication(authentication);
        }

        chain.doFilter(request, response);
    }
}
