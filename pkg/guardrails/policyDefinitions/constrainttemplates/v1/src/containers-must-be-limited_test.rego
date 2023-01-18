package k8scontainerlimits

test_disallowed_no_resources_field_container {
    count(violation) > 0 with input as {
       "review": {
           "object": {
               "spec": {
                   "containers": [
                       {
                       "name": "some-container"
                       }
                   ]
               }
           }
       }
   }
}

test_disallowed_no_resources_field_initcontainer {
    count(violation) > 0 with input as {
       "review": {
           "object": {
               "spec": {
                   "initContainers": [
                       {
                       "name": "some-container"
                       }
                   ]
               }
           }
       }
   }
}

test_disallowed_no_limits_container {
    count(violation) > 0 with input as {
       "review": {
           "object": {
               "spec": {
                   "containers": [
                       {
                       "name": "some-container",
                       "resources":{
                       "requests":{
                       "cpu":"100m",
                       "memory":"100M"
                       }
                       }
                       }
                   ]
               }
           }
       }
   }
}

test_disallowed_no_limits_initContainer {
    count(violation) > 0 with input as {
       "review": {
           "object": {
               "spec": {
                   "initContainers": [
                       {
                       "name": "some-container",
                       "resources":{
                       "requests":{
                       "cpu":"100m",
                       "memory":"100M"
                       }
                       }
                       }
                   ]
               }
           }
       }
   }
}