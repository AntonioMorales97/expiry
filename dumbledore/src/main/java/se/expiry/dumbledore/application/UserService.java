package se.expiry.dumbledore.application;

import se.expiry.dumbledore.domain.Preference;
import se.expiry.dumbledore.domain.User;

import javax.validation.constraints.NotNull;

public interface UserService {

    void changePassword(String id,String oldPassword,String password);

    Preference getPreferences(String id);

    void savePreference(String userId, int sort, boolean reverse);
}
