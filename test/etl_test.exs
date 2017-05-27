defmodule EtlTest do
  use ExUnit.Case
  doctest Etl

  setup do
    on_exit fn ->
      File.rm('test/fixtures/output.csv')
    end
  end

  test "it copies a basic file" do
    {:ok, input}  = File.read('test/fixtures/basic.csv')

    Etl.run('test/fixtures/basic.csv', 'test/fixtures/output.csv')

    {:ok, output} = File.read('test/fixtures/output.csv')

    assert input == output
  end
end
