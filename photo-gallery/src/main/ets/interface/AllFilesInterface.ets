import { FileType, ResourceType } from '../../../../Index';

export interface AllFilesInterface{
  /**
   * 文件名称
   */
  fileName: string;
  /**
   * 文件类型
   */
  fileType: FileType;
  /**
   * 资源类型
   */
  resourceType: ResourceType;
  files: AllFilesInterface[];
}