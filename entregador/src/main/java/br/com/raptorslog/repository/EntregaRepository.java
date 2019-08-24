package br.com.raptorslog.repository;

import br.com.raptorslog.model.Entrega;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "entregas", path = "entregas")
public interface EntregaRepository extends JpaRepository<Entrega, Long> {

}
