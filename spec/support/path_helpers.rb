module PathHelpers
  def project_path
    Pathname.new(File.expand_path('../../../', __FILE__))
  end

  def temp_path
    project_path.join('tmp')
  end

  def spec_path
    project_path.join('spec')
  end

  def fixtures_path
    spec_path.join('fixtures')
  end
end
