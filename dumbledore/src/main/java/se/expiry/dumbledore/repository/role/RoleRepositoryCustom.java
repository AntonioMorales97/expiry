package se.expiry.dumbledore.repository.role;

import se.expiry.dumbledore.domain.Role;

import java.util.List;

public interface RoleRepositoryCustom {

    List<Role> getMatchingRolesForIds(List<String> ids);

}
