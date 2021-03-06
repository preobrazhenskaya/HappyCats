package university.happyCatsSpring.service.impl;

import org.springframework.security.core.userdetails.UsernameNotFoundException;
import university.happyCatsSpring.dto.CreateCatDto;
import university.happyCatsSpring.entity.Breed;
import university.happyCatsSpring.entity.Cat;
import university.happyCatsSpring.entity.User;
import university.happyCatsSpring.repo.BreedRepository;
import university.happyCatsSpring.repo.CatRepository;
import university.happyCatsSpring.repo.UserRepository;
import university.happyCatsSpring.service.iface.CatService;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public class CatServiceImpl implements CatService {
    
    private CatRepository catRepository;
    private UserRepository userRepository;
    private BreedRepository breedRepository;


    public CatServiceImpl(CatRepository catRepository, UserRepository userRepository, BreedRepository breedRepository) {
        this.catRepository = catRepository;
        this.userRepository = userRepository;
        this.breedRepository = breedRepository;
    }

    @Override
    public List<Cat> findAll() {
        return catRepository.findAll();
    }

    @Override
    public Optional<Cat> findById(Long id) {
        return catRepository.findById(id);
    }

    @Override
    public Optional<Cat> findByName(String name) {
        return catRepository.findByName(name);
    }

    @Override
    public Cat addCat(String username, CreateCatDto catDto) throws Exception {
        Optional<User> userOptional = userRepository.findByUsername(username);
        User user = userOptional.orElseThrow(() -> new UsernameNotFoundException("User " + username +" not found"));
        Optional<Breed> breedOptional = breedRepository.findByName(catDto.getBreed());
        Breed breed = breedOptional.orElseThrow(() -> new Exception("Breed not found"));

        String birthday = catDto.getBirthday();
        String name = catDto.getName();
        String photo = catDto.getPhoto();
        String note = catDto.getNote();

        Cat cat = new Cat();
        cat.setBreed(breed);

        if(name != null && !name.trim().isEmpty())
            cat.setName(name);

        if(birthday != null && !birthday.trim().isEmpty())
            cat.setBirthday(birthday);

        if(photo != null && !photo.trim().isEmpty())
            cat.setPhoto(photo);

        if(note != null && !note.trim().isEmpty())
            cat.setNote(note);

        Set<Cat> catSet = user.getCats();
        catSet.add(cat);
        user.setCats(catSet);
        catRepository.save(cat);
        userRepository.save(user);
        return cat;
    }

    @Override
    public Cat updateCat(Cat cat, CreateCatDto catDto) throws Exception {
        String newBirthday = catDto.getBirthday();
        String newName = catDto.getName();
        String newPhoto = catDto.getPhoto();
        String newNote = catDto.getNote();
        String newBreed = catDto.getBreed();

        if(newBreed != null && !newBreed.trim().isEmpty()) {
            Optional<Breed> breedOptional = breedRepository.findByName(newBreed);
            Breed breed = breedOptional.orElseThrow(() -> new Exception(" Breed " + newBreed + "not found."));
            cat.setBreed(breed);
        }

        if(newName != null && !newName.trim().isEmpty())
            cat.setName(newName);

        if(newBirthday != null && !newBirthday.trim().isEmpty())
            cat.setBirthday(newBirthday);

        if(newPhoto != null && !newPhoto.trim().isEmpty())
            cat.setPhoto(newPhoto);

        if(newNote != null && !newNote.trim().isEmpty())
            cat.setNote(newNote);

        return catRepository.save(cat);
    }

    @Override
    public User deleteCat(Cat cat, String username) throws  Exception {
        Optional<User> userOptional = userRepository.findByUsername(username);
        User user = userOptional.orElseThrow(() -> new UsernameNotFoundException("User " + username +" not found"));
        Set<Cat> cats = user.getCats();
        cats.remove(cat);
        return userRepository.save(user);
    }


}
