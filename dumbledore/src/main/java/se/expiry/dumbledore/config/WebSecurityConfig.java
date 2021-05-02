package se.expiry.dumbledore.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import se.expiry.dumbledore.config.security.AccessDeniedHandlerJson;
import se.expiry.dumbledore.config.security.FiltchAuthEntryPoint;
import se.expiry.dumbledore.config.security.FiltchAuthFilter;
import se.expiry.dumbledore.config.security.FiltchAuthProvider;
import se.expiry.dumbledore.presentation.controller.LogController;

@Configuration
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {


    private FiltchAuthProvider filtchAuthProvider;

    public WebSecurityConfig(FiltchAuthProvider filtchAuthProvider) {
        this.filtchAuthProvider = filtchAuthProvider;
    }

    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring().mvcMatchers("/log" + LogController.ERROR_LOG);
    }

    /**
     * Layer below WebSecurity. Sets up security against the API and adds filters.
     *
     * @param http The <code>HttpSecurity</code> to configure.
     **/
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .httpBasic().disable()
                .formLogin().disable()
                .logout().disable()
                .csrf().disable()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                .mvcMatchers("/admin/**").hasRole("ROLE_ADMIN")
                .mvcMatchers("/**").authenticated()
                .and()
                .exceptionHandling().authenticationEntryPoint(new FiltchAuthEntryPoint())
                .and()
                .exceptionHandling().accessDeniedHandler(new AccessDeniedHandlerJson())
                .and()
                .addFilterBefore(new FiltchAuthFilter(filtchAuthProvider), UsernamePasswordAuthenticationFilter.class);
    }
}