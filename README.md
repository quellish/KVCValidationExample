Demonstrates a simple use of Key Value Coding Validation.
The example is a simple application displaying a text field. Any text field value other than "John" will not pass validation and will display an error. This shows how to use Key-Value Coding validation properly to perform validation before setting a model object value.


You should not perform validation inside an overriden setter. Instead, you should do so in the code that *calls* the setter, such as an action method.

Don't do this:

    - (void) setName:(NSString *)value {
        if ([self validateValue:&value forKey:@"name" error:nil]){
            name = value;
        } else {
        }
    }
    
See `ViewController` for an example of a correct implementation for a `UITextField`.
    
While you should implement validation methods that follow the pattern of `validate<Key>:error:`, you should not call those methods directly. Instead call `validateValue:forKey:error:`, which will find and use those methods. Obviously in your implementation of `validate<Key>:error:` you should not call into `validateValue:forKey:error:`, which would cause an infinite loop.

This example does not cover how to modify a value inside a validation method. That will be covered in another project, as that has some additional complications.

While this example is not specific to CoreData, all of these rules apply to validation intended to be used with CoreData. Effective use of validation methods with Core Data will be part of another example project. You can, and should, follow this example when implementing a user interface that modifies a Core Data managed object even if you do not implement your own validation methods - CoreData provides implementations of validation methods at runtime that work with this example.