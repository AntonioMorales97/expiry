package se.expiry.dumbledore.application;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.Preference;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.repository.user.UserRepository;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService{

    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void changePassword(String id, String oldPassword,String password) {
        Optional<User> user = userRepo.findById(id);
        if(user.isEmpty()){
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "No user found by id");
            throw new ExpiryException(exceptionDetail);
        }

        boolean match = passwordEncoder.matches(oldPassword,user.get().getPassword());
        if(!match){
            ExceptionDetail exceptionDetail = new ExceptionDetail(403, "Old password was incorrect");
            throw new ExpiryException(exceptionDetail);
        }
        String hashedPassword = passwordEncoder.encode(password);
       if( userRepo.changePassword( id  ,hashedPassword) == null){
           ExceptionDetail exceptionDetail = new ExceptionDetail(404, "Could not find resource to update.");
           throw new ExpiryException(exceptionDetail);
       }
    }

    @Override
    public Preference getPreferences(String userId) {
        User user = controllUser(userId);
        return user.getPreference();
    }

    @Override
    public void savePreference(String userId, int sort, boolean reverse) {
        User user = controllUser(userId);
        user.setPreference(new Preference(sort, reverse));
        userRepo.save(user);


    }
    private User controllUser(String userId){
        Optional<User> user = userRepo.findById(userId);
        if(user.isEmpty()){
            ExceptionDetail exceptionDetail = new ExceptionDetail(400, "No user found by id");
            throw new ExpiryException(exceptionDetail);
        }
        return user.get();
    }
}
