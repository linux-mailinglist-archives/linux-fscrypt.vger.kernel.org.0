Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB6737D4E6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 May 2021 23:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbhELSeX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 May 2021 14:34:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34703 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354546AbhELS0W (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 May 2021 14:26:22 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 6C2E15C0117;
        Wed, 12 May 2021 14:25:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 May 2021 14:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=fm3; bh=BsSyihGXISq+f51f4VXvaYdk1DjK4E2pZPAk0iUz
        H4k=; b=OSFGvhM5NZc6qqmnI0O/BoaJDLUxjpRjmBOt3q2s3o/ihDV3oW+i0jZQ
        GiXNfgmgmC2kaYWYzx9xvDeqJmQd2GiFH5Vg8eR8NnOq7oWGxzM3MafUe5iqNkSD
        LZ2fMtApakZWKWBVmgGv2yFhEEdIj4ruH+/yR0Wkgu842r4sf7TfGw1HxsSRa7OT
        4zMyvXK29i+iOOYKJaJDYHoQbjlaEQA563Yhu1pWWQusFVsnJN2YlbicvmWBpCP8
        VeTQPn9sHTrIovFNyI1R4wSRZQ0zt5q3g+1jJiIlayCl3WaCWhZco1Sorqp+M7N7
        UBLf26hzZ+WYtMlLzhjqgubNRY4nsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BsSyih
        GXISq+f51f4VXvaYdk1DjK4E2pZPAk0iUzH4k=; b=LMNI4WX2PW86hkOipnVuL+
        s2X0IYKLrJgui1RRfGb8hxiodaa7ua89z5iEdsKSwZBxffMa91cuSWyzCqKVIuu+
        f/S/+K9HXX7T1AR4Lw8RyFJ9pwgZhC+yE4TsLz41XS/B2UR4zWmBAnjQ1odmvP4+
        CcQVJ5guVvyajrSMhVEBqEV7Z0bpj60HNfEvr7vuorYVXKkkfzo3HL7sCvAYZErz
        eVEkBGPe5G6ul1MZDzTG3gehy5CHMVX0318w5esLE5uvUBJgt5wbomX4/Rr5Uabn
        +ghWhxm+LCSMfIP306BjtoxWOQHAYjmnzZskykKLjO/ZVABTlIJFGSurEUTS2FTw
        ==
X-ME-Sender: <xms:iB2cYCRFWSyXzDAlO-XR3UteEueOGsVX_U-U88PXakMtWba7AYZFyA>
    <xme:iB2cYHzkRlOgVwXGEvsbJpVMh6miDY_NOVY4Op_9VqL_KxlM8CYKEZfuDlxTQKK5A
    6oJ44M6VWI_g25HQqU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepheduveelkeeiteelveeiuefhudehtdeigfehke
    effeegledvueevgefgudeuveefnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:iB2cYP0IJ0gll9_WAhijdyjxJwe8GyAlVag1n93gkz-nmT6JW3jcaA>
    <xmx:iB2cYOCN0b44ttGPwhMcXr6G7heHhoDJgJtem30MGF_piQOl7hl2yQ>
    <xmx:iB2cYLhsdMsyi7_zZGKg0XgsXjXaBNPL7CdhT3xY_meiBc86PpBQuw>
    <xmx:iR2cYDZ12HwD8CpFyeLwNF4yoma9QmmOz2cH0r4Cfnt21PgzUkQ8AQ>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 14:25:12 -0400 (EDT)
Date:   Wed, 12 May 2021 11:25:11 -0700
From:   Boris Burkov <boris@bur.io>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 3/5] btrfs: check verity for reads of inline extents
 and holes
Message-ID: <YJwdfF+q+ACLO8G4@zen>
References: <cover.1620240133.git.boris@bur.io>
 <0cf02de467f18881ed84e483e21975ffdc86abca.1620241221.git.boris@bur.io>
 <20210512175754.GW7604@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512175754.GW7604@twin.jikos.cz>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 12, 2021 at 07:57:54PM +0200, David Sterba wrote:
> On Wed, May 05, 2021 at 12:20:41PM -0700, Boris Burkov wrote:
> > The majority of reads receive a verity check after the bio is complete
> > as the page is marked uptodate. However, there is a class of reads which
> > are handled with btrfs logic in readpage, rather than by submitting a
> > bio. Specifically, these are inline extents, preallocated extents, and
> > holes. Tweak readpage so that if it is going to mark such a page
> > uptodate, it first checks verity on it.
> 
> So verity works with inline extents and fills the unused space by zeros
> before hashing?

There is no special logic to zero the unused space for verity, we just
ship the page off to the VFS verity code before marking it Uptodate. The
inline extent logic in btrfs_get_extent does zero the parts of the page
past the data copied in.

> 
> > Now if a veritied file has corruption to this class of EXTENT_DATA
> > items, it will be detected at read time.
> > 
> > There is one annoying edge case that requires checking for start <
> > last_byte: if userspace reads to the end of a file with page aligned
> > size and then tries to keep reading (as cat does), the buffered read
> > code will try to read the page past the end of the file, and expects it
> > to be filled with 0s and marked uptodate. That bogus page is not part of
> > the data hashed by verity, so we have to ignore it.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  fs/btrfs/extent_io.c | 26 +++++++-------------------
> >  1 file changed, 7 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index d1f57a4ad2fb..d1493a876915 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -2202,18 +2202,6 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
> >  	return bitset;
> >  }
> >  
> > -/*
> > - * helper function to set a given page up to date if all the
> > - * extents in the tree for that page are up to date
> > - */
> > -static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
> > -{
> > -	u64 start = page_offset(page);
> > -	u64 end = start + PAGE_SIZE - 1;
> > -	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
> > -		SetPageUptodate(page);
> > -}
> > -
> >  int free_io_failure(struct extent_io_tree *failure_tree,
> >  		    struct extent_io_tree *io_tree,
> >  		    struct io_failure_record *rec)
> > @@ -3467,14 +3455,14 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
> >  					    &cached, GFP_NOFS);
> >  			unlock_extent_cached(tree, cur,
> >  					     cur + iosize - 1, &cached);
> > -			end_page_read(page, true, cur, iosize);
> > +			ret = end_page_read(page, true, cur, iosize);
> 
> Latest version of end_page_read does not return any value.

In case you missed it, I modified it to return a value in the second
patch (btrfs: initial support for fsverity)

> 
> >  			break;
> >  		}
> >  		em = __get_extent_map(inode, page, pg_offset, cur,
> >  				      end - cur + 1, em_cached);
> >  		if (IS_ERR_OR_NULL(em)) {
> >  			unlock_extent(tree, cur, end);
> > -			end_page_read(page, false, cur, end + 1 - cur);
> > +			ret = end_page_read(page, false, cur, end + 1 - cur);
> >  			break;
> >  		}
> >  		extent_offset = cur - em->start;
> > @@ -3555,9 +3543,10 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
> >  
> >  			set_extent_uptodate(tree, cur, cur + iosize - 1,
> >  					    &cached, GFP_NOFS);
> > +
> >  			unlock_extent_cached(tree, cur,
> >  					     cur + iosize - 1, &cached);
> > -			end_page_read(page, true, cur, iosize);
> > +			ret = end_page_read(page, true, cur, iosize);
> 
> And if it would, you'd have to check it in all cases when it's not
> followed by break, like here.

Agreed. I think I got "lucky" because the continues all break the loop in
the cases I've tried. Thinking about it more, it looks like I need to set
the error bit on the page too, so that might work without end_page_read
having a return value.

> 
> >  			cur = cur + iosize;
> >  			pg_offset += iosize;
> >  			continue;
> > @@ -3565,9 +3554,8 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
> >  		/* the get_extent function already copied into the page */
> >  		if (test_range_bit(tree, cur, cur_end,
> >  				   EXTENT_UPTODATE, 1, NULL)) {
> > -			check_page_uptodate(tree, page);
> >  			unlock_extent(tree, cur, cur + iosize - 1);
> > -			end_page_read(page, true, cur, iosize);
> > +			ret = end_page_read(page, true, cur, iosize);
> >  			cur = cur + iosize;
> >  			pg_offset += iosize;
> >  			continue;
> > @@ -3577,7 +3565,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
> >  		 */
> >  		if (block_start == EXTENT_MAP_INLINE) {
> >  			unlock_extent(tree, cur, cur + iosize - 1);
> > -			end_page_read(page, false, cur, iosize);
> > +			ret = end_page_read(page, false, cur, iosize);
> >  			cur = cur + iosize;
> >  			pg_offset += iosize;
> >  			continue;
> > @@ -3595,7 +3583,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
> >  			*bio_flags = this_bio_flag;
> >  		} else {
> >  			unlock_extent(tree, cur, cur + iosize - 1);
> > -			end_page_read(page, false, cur, iosize);
> > +			ret = end_page_read(page, false, cur, iosize);
> >  			goto out;
> >  		}
> >  		cur = cur + iosize;
> > -- 
> > 2.30.2
