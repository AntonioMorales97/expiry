package se.expiry.dumbledore.util;

import org.springframework.beans.BeanWrapperImpl;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class AtLeastOneNotNullValidator implements ConstraintValidator<FieldMatch, Object> {
    private String firstFieldName;
    private String secondFieldName;

    @Override
    public void initialize(final FieldMatch constraintAnnotation) {
        firstFieldName = constraintAnnotation.first();
        secondFieldName = constraintAnnotation.second();
    }

    @Override
    public boolean isValid(Object value, ConstraintValidatorContext context) {

        BeanWrapperImpl wrapper = new BeanWrapperImpl(value);
        BeanWrapperImpl wrapperTwo = new BeanWrapperImpl(value);
        final Object firstObj = wrapper.getPropertyValue(firstFieldName);
        final Object secondObj = wrapperTwo.getPropertyValue(secondFieldName);

        return firstObj != null || secondObj != null;
    }
}
