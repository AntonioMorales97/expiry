package se.expiry.dumbledore.application;

import se.expiry.dumbledore.domain.User;

import javax.validation.constraints.NotNull;

public interface UserService {

    User changePassword(@NotNull String passwordResetRequestModelId, String id, String password);
}