package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.Role;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.repository.role.RoleRepository;
import se.expiry.dumbledore.repository.store.StoreRepository;
import se.expiry.dumbledore.repository.user.UserRepository;
import se.expiry.dumbledore.util.Roles;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringJUnitConfig
public class AdminServiceImplTests {

    private AdminServiceImpl adminService;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private StoreRepository storeRepository;

    @MockBean
    private RoleRepository roleRepository;

    @MockBean
    private PasswordEncoder passwordEncoder;

    @Mock
    private UpdateResult updateResult;

    @Mock
    private List<Store> mockedStores;

    private static final String FIRST_NAME = "John";
    private static final String LAST_NAME = "Doe";
    private static final String EMAIL = "john@email.com";
    private static final String PASSWORD = "secret";
    private static final String HASHED_PASSWORD = "hashed123";
    private static final List<Role> ROLES = Arrays.asList(new Role(Roles.ROLE_USER));
    private static final int NUMBER_OF_STORES = 2;

    private User user;

    @BeforeEach
    public void setUp() {
        this.adminService = new AdminServiceImpl(storeRepository, roleRepository, userRepository, passwordEncoder);
        Mockito.when(passwordEncoder.encode(Mockito.anyString())).thenReturn(HASHED_PASSWORD);
        this.user = new User(FIRST_NAME, LAST_NAME, EMAIL, HASHED_PASSWORD,ROLES);
        Mockito.when(userRepository.save(Mockito.any(User.class))).thenReturn(user);
    }

    @Test
    @DisplayName("add user with ROLE_USER successfully")
    public void addUserSuccessfully(){
        AddUserRequestModel addUserRequestModel = createValidAddUserRequestModel();

        Mockito.when(storeRepository.findAllById(Mockito.anyList())).thenReturn(mockedStores);
        Mockito.when(mockedStores.size()).thenReturn(NUMBER_OF_STORES);
        Mockito.when(roleRepository.findByName(Mockito.anyString())).thenReturn(java.util.Optional.of(new Role("ROLE_USER")));

        User returnedUser = adminService.addUser(addUserRequestModel);

        assertNotNull(returnedUser);
        assertEquals(user, returnedUser);
    }

    @Test
    @DisplayName("all stores not found")
    public void someStoresCouldNotBeFound(){
        AddUserRequestModel addUserRequestModel = createValidAddUserRequestModel();

        Mockito.when(storeRepository.findAllById(Mockito.anyList())).thenReturn(mockedStores);
        Mockito.when(mockedStores.size()).thenReturn(0);
        Mockito.when(roleRepository.findByName(Mockito.anyString())).thenReturn(java.util.Optional.of(new Role("ROLE_USER")));

        ExpiryException expiryException = assertThrows(ExpiryException.class, () -> adminService.addUser(addUserRequestModel),
                "Expected addUser() to throw ExpiryException but did not"
                );

        assertTrue(expiryException.getExceptionDetail().getDetail().contains("found"));
    }

    private AddUserRequestModel createValidAddUserRequestModel(){
        AddUserRequestModel addUserRequestModel = new AddUserRequestModel();
        addUserRequestModel.setEmail(EMAIL);
        addUserRequestModel.setFirstName(FIRST_NAME);
        addUserRequestModel.setLastName(LAST_NAME);
        addUserRequestModel.setPassword(PASSWORD);
        addUserRequestModel.setRePassword(PASSWORD);
        List<String> stores = new ArrayList<>();
        stores.add("gallerian");
        stores.add("normal");
        addUserRequestModel.setStoreIds(stores);
        return addUserRequestModel;
    }
}
