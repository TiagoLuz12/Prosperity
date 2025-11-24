package Prosperity;

public class Paciente {
	import java.time.LocalDate;

	@Entity
	@Table(name = "PACIENTE")
	public class Paciente {

	 @Id
	 @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column(name = "ID_Paciente")
	 private Long id;

	 @Column(name = "Nome", nullable = false, length = 150)
	 private String nome;

	 @Column(name = "CPF", unique = true, length = 14)
	 private String cpf;

	 @Column(name = "Telefone", nullable = false, length = 15)
	 private String telefone;

	 @Column(name = "Endereco", length = 255)
	 private String endereco;

	 @Column(name = "Data_Nascimento")
	 private LocalDate dataNascimento;

	 @ManyToOne
	 @JoinColumn(name = "ID_Usuario")
	 private Usuario usuario;

	 // getters e setters
	}
