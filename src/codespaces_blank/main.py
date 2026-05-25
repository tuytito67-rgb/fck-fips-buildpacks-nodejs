import dagger
from dagger import dag, function, object_type


@object_type
class CodespacesBlank:
    @function
    def simple_dir(self) -> dagger.Directory:
        return dag.directory().with_new_file("that/test.txt", "Hello from Dagger!")
    
    @function
    def simple_another_dir(self) -> dagger.Directory:
        """hi just  a funny try"""
        inner = dag.directory()

        l=(dag.directory()
            .with_new_file("l1/test.txt","im here")
            .with_new_file("l2/test.text","im here")
            .with_directory("l3",inner))
        return l