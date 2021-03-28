package se.expiry.dumbledore;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import se.expiry.dumbledore.application.AdminService;
import se.expiry.dumbledore.config.security.FiltchAuthProvider;
import se.expiry.dumbledore.config.WebSecurityConfig;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.controller.AdminController;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;

import static org.mockito.BDDMockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(AdminController.class)
@ContextConfiguration(classes = {AdminController.class, WebSecurityConfig.class})
public class AdminControllerSliceTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AdminService adminService;

    @MockBean
    private FiltchAuthProvider filtchAuthProvider;

    //TODO: Add admin role
    @DisplayName("User with admin role add user successfully")
    @Test
    @WithMockUser(username = "John")
    public void adminAddUser() throws Exception {

        AddUserRequestModel req = new AddUserRequestModel();
        req.setFirstName("John");
        req.setPassword("123123");
        req.setRePassword("123123");
        req.setLastName("Doe");
        req.setEmail("john@email.com");

        User user = new User("John", "Doe", "john@email.com", "123123");

        given(adminService.addUser(req)).willReturn(user);

        mockMvc.perform(
                post("/admin/user")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(asJsonString(req))
                )
                .andExpect(status().isOk())
                .andExpect(jsonPath("firstName").value("John"));

        verify(adminService, Mockito.times(1)).addUser(req);
    }

    protected static String asJsonString(final Object obj) {
        try {
            final ObjectMapper mapper = new ObjectMapper();
            final String jsonContent = mapper.writeValueAsString(obj);
            return jsonContent;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
