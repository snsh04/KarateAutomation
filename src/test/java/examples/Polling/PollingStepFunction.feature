Feature: Poll

Background:
# not required 


@parellel=false
Scenario:
 * def sleep =
      """
      function(seconds){
        for(i = 0; i <= seconds; i++)
        {
          java.lang.Thread.sleep(1*1000);

        }
      }
      """
    * call sleep 20
