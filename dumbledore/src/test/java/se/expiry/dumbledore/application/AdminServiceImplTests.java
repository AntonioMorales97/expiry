package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import org.bson.BsonValue;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.repository.StoreRepository;
import se.expiry.dumbledore.repository.UserRepository;

import java.util.ArrayList;
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
    private PasswordEncoder passwordEncoder;

    @Mock
    private UpdateResult updateResult;

    private static final String FIRST_NAME = "John";
    private static final String LAST_NAME = "Doe";
    private static final String EMAIL = "john@email.com";
    private static final String PASSWORD = "secret";
    private static final String HASHED_PASSWORD = "hashed123";
    private static final int NUMBER_OF_STORES = 2;

    private User user;

    @Value("${}")

    @BeforeEach
    public void setUp() {
        this.adminService = new AdminServiceImpl(storeRepository, userRepository, passwordEncoder);
        Mockito.when(passwordEncoder.encode(Mockito.anyString())).thenReturn(HASHED_PASSWORD);
        this.user = new User(FIRST_NAME, LAST_NAME, EMAIL, HASHED_PASSWORD);
        Mockito.when(userRepository.save(Mockito.any(User.class))).thenReturn(user);
    }

    @Test
    @DisplayName("add user successfully")
    public void addUserSuccessfully(){
        AddUserRequestModel addUserRequestModel = createValidAddUserRequestModel();

        Mockito.when(storeRepository.addUserToStores(Mockito.eq(user), Mockito.anyList())).thenReturn(updateResult);
        Mockito.when(updateResult.getMatchedCount()).thenReturn((long) NUMBER_OF_STORES);
        Mockito.when(updateResult.getModifiedCount()).thenReturn((long) NUMBER_OF_STORES);

        User returnedUser = adminService.addUser(addUserRequestModel);

        assertNotNull(returnedUser);
        assertEquals(user, returnedUser);
    }
    @Test
    @DisplayName("all stores not found")
    public void allStoresCouldNotBeFound(){
        AddUserRequestModel addUserRequestModel = createValidAddUserRequestModel();

        Mockito.when(storeRepository.addUserToStores(Mockito.eq(user), Mockito.anyList())).thenReturn(updateResult);
        Mockito.when(updateResult.getMatchedCount()).thenReturn((long) 0);

        ExpiryException expiryException = assertThrows(ExpiryException.class, () -> adminService.addUser(addUserRequestModel),
                "Expected addUser() to throw ExpiryException but did not"
                );

        assertTrue(expiryException.getExceptionDetail().getDetail().contains("found"));
    }

    @Test
    @DisplayName("all stores not updated")
    public void allStoresCouldNotBeUpdated(){
        AddUserRequestModel addUserRequestModel = createValidAddUserRequestModel();

        Mockito.when(storeRepository.addUserToStores(Mockito.eq(user), Mockito.anyList())).thenReturn(updateResult);
        Mockito.when(updateResult.getMatchedCount()).thenReturn((long) NUMBER_OF_STORES);
        Mockito.when(updateResult.getModifiedCount()).thenReturn((long) 0);

        ExpiryException expiryException = assertThrows(ExpiryException.class, () -> adminService.addUser(addUserRequestModel),
                "Expected addUser() to throw ExpiryException but did not"
        );

        assertTrue(expiryException.getExceptionDetail().getDetail().contains("updated"));
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
        addUserRequestModel.setStores(stores);
        return addUserRequestModel;
    }

    private UpdateResult getUpdatedResult(int matchedCount, int modifiedCount){
        return new UpdateResult() {
            @Override
            public boolean wasAcknowledged() {
                return false;
            }

            @Override
            public long getMatchedCount() {
                return matchedCount;
            }

            @Override
            public long getModifiedCount() {
                return modifiedCount;
            }

            @Override
            public BsonValue getUpsertedId() {
                return null;
            }
        };
    }
}
