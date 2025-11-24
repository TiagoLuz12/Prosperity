package Prosperity;

public class Dentista {
	import javax.persistence.*;

	@Entity
	@Table(name = "DENTISTA")
	public class Dentista {

	 @Id
	 @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column(name = "ID_Dentista")
	 private Long id;

	 @Column(name = "Nome", nullable = false, length = 150)
	 private String nome;

	 @Column(name = "CRO", nullable = false, unique = true, length = 20)
	 private String cro;

	 @Column(name = "Especialidade", length = 100)
	 private String especialidade;

	 @Column(name = "Telefone", length = 15)
	 private String telefone;

	 @ManyToOne
	 @JoinColumn(name = "ID_Usuario")
	 private Usuario usuario;

	 // getters e setters
	}
}
