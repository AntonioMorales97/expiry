package se.expiry.dumbledore.repository.log;

import org.springframework.data.mongodb.repository.MongoRepository;
import se.expiry.dumbledore.domain.Log;


public interface LogRepository extends MongoRepository<Log,String> {

}
