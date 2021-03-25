package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import org.bson.BsonValue;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
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

    @BeforeEach
    public void setUp() throws Exception {
        this.adminService = new AdminServiceImpl(storeRepository, userRepository, passwordEncoder);
    }

    @Test
    @DisplayName("add user successfully")
    public void addUserSuccessfully(){
        AddUserRequestModel addUserRequestModel = createValidAddUserRequestModel();
        String hashedPassword = "hashed";
        Mockito.when(passwordEncoder.encode(Mockito.anyString())).thenReturn(hashedPassword);
        User user = new User(addUserRequestModel.getFirstName(), addUserRequestModel.getLastName(), addUserRequestModel.getEmail(), hashedPassword);
        Mockito.when(userRepository.save(Mockito.any(User.class))).thenReturn(user);

        Mockito.when(storeRepository.addUserToStores(user, addUserRequestModel.getStores())).thenReturn(getUpdatedResult(
                addUserRequestModel.getStores().size(), addUserRequestModel.getStores().size()
        ));

        User returnedUser = adminService.addUser(addUserRequestModel);

        assertNotNull(returnedUser);
        assertEquals(user, returnedUser);
    }


    private AddUserRequestModel createValidAddUserRequestModel(){
        AddUserRequestModel addUserRequestModel = new AddUserRequestModel();
        addUserRequestModel.setEmail("john@email.com");
        addUserRequestModel.setFirstName("john");
        addUserRequestModel.setLastName("doe");
        addUserRequestModel.setPassword("123123");
        addUserRequestModel.setRePassword("123123");
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
