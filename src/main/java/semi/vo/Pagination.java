package semi.vo;

public class Pagination {
	private int rowsPerPage = 5;
	private int pagePerBlock = 5;
	private int currentPage;
	private int currentBlock;
	private int totalRecords;	

	private int begin;
	private int end;
	private int beginPage;
	private int endPage;
	
	private int prevPage;
	private int nextPage;
	private int totalBlock;
	private int totalPage;
	
	public Pagination(String pageNo, int totalRecords) {
		totalPage = (int)(Math.ceil((double)totalRecords/rowsPerPage));
		totalBlock = (int)(Math.ceil((double)totalPage/pagePerBlock));
		
		currentPage = 1;
		try {
			currentPage = Integer.parseInt(pageNo);
		} catch (NumberFormatException e) {
			
		}

		if (currentPage <= 0 ) {
			currentPage = 1;
		}
		if (currentPage > totalPage) {
			currentPage = totalPage;
		}
		
		begin = (currentPage - 1)*rowsPerPage + 1;
		end = currentPage*rowsPerPage;
		
		
		currentBlock = (int)(Math.ceil((double)currentPage/pagePerBlock));
		
		beginPage = (currentBlock - 1)*pagePerBlock + 1; 
		endPage = currentBlock*pagePerBlock; 
		
		if (currentBlock == totalBlock) {
			endPage = totalPage;
		}
		
		// 현재 페이지번호에 대한 이전 블록의 페이지번호를 계산해서 멤버변수에 대입한다.
		if (currentBlock > 1) {
			prevPage = (currentBlock - 1)*pagePerBlock;
		}
		// 현재 페이지번호에 대한 다음 블록의 페이지번호를 계산해서 멤버변수에 대입한다.
		if (currentBlock < totalBlock) {
			nextPage = currentBlock*pagePerBlock + 1;
		}
	}


	/**
	 * 계산된 현재 페이지번호를 반환한다.
	 * @return 페이지번호
	 */
	public int getPageNo() {
		return currentPage;
	}

	/**
	 * 총 게시글 갯수를 반환한다.
	 * @return 총 게시글 갯수
	 */
	public int getTotalRecords() {
		return totalRecords;
	}

	/**
	 * 총 페이지 갯수를 반환한다.
	 * @return 총 페이지 갯수
	 */
	public int getTotalPages() {
		return totalPage;
	}

	/**
	 * 시작 페이지번호를 반환한다.
	 * @return 시작 페이지번호
	 */
	public int getBeginPage() {
		return beginPage;
	}

	/**
	 * 끝 페이지번호를 반환한다.
	 * @return 끝 페이지번호
	 */
	public int getEndPage() {
		return endPage;
	}

	/**
	 * 조회 시작 순번을 반환한다.
	 * @return  조회 시작 순번
	 */
	public int getBegin() {
		return begin;
	}
	
	/**
	 * 이전 블록의 페이지번호를 반환한다.
	 * @return 페이지번호
	 */
	public int getPrevPage() {
		return prevPage;
	}
	
	/**
	 * 이전 블록 존재여부를 반환한다.
	 * @return 이전 블록 존재 여부
	 */
	public boolean isExistPrev() {
		if (totalBlock == 1) {
			return false;
		}
		return currentBlock > 1;
	}
	
	/**
	 * 다음 블록 존재여부를 반환한다.
	 * @return 다음 블록 존재 여부
	 */
	public boolean isExistNext() {
		if (totalBlock == 1) {
			return false;
		}
		
		return currentBlock < totalBlock;
	}
	
	/**
	 * 다음 블록의 페이지번호를 반환한다.
	 * @return 페이지번호
	 */
	public int getNextPage() {
		return nextPage;
	}

	/**
	 * 조회 끝 순번을 반환한다.
	 * @return 조회 끝 순번
	 */
	public int getEnd() {
		return end;
	}
	
}
