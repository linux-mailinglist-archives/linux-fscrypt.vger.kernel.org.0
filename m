Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6594337D4E4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 May 2021 23:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243454AbhELSeL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 May 2021 14:34:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:48656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351642AbhELSBe (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 May 2021 14:01:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E745FB201;
        Wed, 12 May 2021 18:00:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0E562DA83F; Wed, 12 May 2021 19:57:55 +0200 (CEST)
Date:   Wed, 12 May 2021 19:57:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 3/5] btrfs: check verity for reads of inline extents
 and holes
Message-ID: <20210512175754.GW7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1620240133.git.boris@bur.io>
 <0cf02de467f18881ed84e483e21975ffdc86abca.1620241221.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cf02de467f18881ed84e483e21975ffdc86abca.1620241221.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 05, 2021 at 12:20:41PM -0700, Boris Burkov wrote:
> The majority of reads receive a verity check after the bio is complete
> as the page is marked uptodate. However, there is a class of reads which
> are handled with btrfs logic in readpage, rather than by submitting a
> bio. Specifically, these are inline extents, preallocated extents, and
> holes. Tweak readpage so that if it is going to mark such a page
> uptodate, it first checks verity on it.

So verity works with inline extents and fills the unused space by zeros
before hashing?

> Now if a veritied file has corruption to this class of EXTENT_DATA
> items, it will be detected at read time.
> 
> There is one annoying edge case that requires checking for start <
> last_byte: if userspace reads to the end of a file with page aligned
> size and then tries to keep reading (as cat does), the buffered read
> code will try to read the page past the end of the file, and expects it
> to be filled with 0s and marked uptodate. That bogus page is not part of
> the data hashed by verity, so we have to ignore it.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/extent_io.c | 26 +++++++-------------------
>  1 file changed, 7 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d1f57a4ad2fb..d1493a876915 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2202,18 +2202,6 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  	return bitset;
>  }
>  
> -/*
> - * helper function to set a given page up to date if all the
> - * extents in the tree for that page are up to date
> - */
> -static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
> -{
> -	u64 start = page_offset(page);
> -	u64 end = start + PAGE_SIZE - 1;
> -	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
> -		SetPageUptodate(page);
> -}
> -
>  int free_io_failure(struct extent_io_tree *failure_tree,
>  		    struct extent_io_tree *io_tree,
>  		    struct io_failure_record *rec)
> @@ -3467,14 +3455,14 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
>  					    &cached, GFP_NOFS);
>  			unlock_extent_cached(tree, cur,
>  					     cur + iosize - 1, &cached);
> -			end_page_read(page, true, cur, iosize);
> +			ret = end_page_read(page, true, cur, iosize);

Latest version of end_page_read does not return any value.

>  			break;
>  		}
>  		em = __get_extent_map(inode, page, pg_offset, cur,
>  				      end - cur + 1, em_cached);
>  		if (IS_ERR_OR_NULL(em)) {
>  			unlock_extent(tree, cur, end);
> -			end_page_read(page, false, cur, end + 1 - cur);
> +			ret = end_page_read(page, false, cur, end + 1 - cur);
>  			break;
>  		}
>  		extent_offset = cur - em->start;
> @@ -3555,9 +3543,10 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
>  
>  			set_extent_uptodate(tree, cur, cur + iosize - 1,
>  					    &cached, GFP_NOFS);
> +
>  			unlock_extent_cached(tree, cur,
>  					     cur + iosize - 1, &cached);
> -			end_page_read(page, true, cur, iosize);
> +			ret = end_page_read(page, true, cur, iosize);

And if it would, you'd have to check it in all cases when it's not
followed by break, like here.

>  			cur = cur + iosize;
>  			pg_offset += iosize;
>  			continue;
> @@ -3565,9 +3554,8 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
>  		/* the get_extent function already copied into the page */
>  		if (test_range_bit(tree, cur, cur_end,
>  				   EXTENT_UPTODATE, 1, NULL)) {
> -			check_page_uptodate(tree, page);
>  			unlock_extent(tree, cur, cur + iosize - 1);
> -			end_page_read(page, true, cur, iosize);
> +			ret = end_page_read(page, true, cur, iosize);
>  			cur = cur + iosize;
>  			pg_offset += iosize;
>  			continue;
> @@ -3577,7 +3565,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
>  		 */
>  		if (block_start == EXTENT_MAP_INLINE) {
>  			unlock_extent(tree, cur, cur + iosize - 1);
> -			end_page_read(page, false, cur, iosize);
> +			ret = end_page_read(page, false, cur, iosize);
>  			cur = cur + iosize;
>  			pg_offset += iosize;
>  			continue;
> @@ -3595,7 +3583,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
>  			*bio_flags = this_bio_flag;
>  		} else {
>  			unlock_extent(tree, cur, cur + iosize - 1);
> -			end_page_read(page, false, cur, iosize);
> +			ret = end_page_read(page, false, cur, iosize);
>  			goto out;
>  		}
>  		cur = cur + iosize;
> -- 
> 2.30.2
