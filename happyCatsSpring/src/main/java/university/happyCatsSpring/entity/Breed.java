package university.happyCatsSpring.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.Set;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "breed")
public class Breed {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String name;

    private String photo;

    @Column (length=16384)
    private String description;

    @ManyToMany
    private Set<Disease> diseases;

    public Breed(String name, String photo, String description) {
        this.name = name;
        this.photo = photo;
        this.description = description;
    }

    public Breed(String name, String photo, String description, Set<Disease> diseases) {
        this.name = name;
        this.photo = photo;
        this.description = description;
        this.diseases = diseases;
    }
}
