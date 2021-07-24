Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011EA3D459A
	for <lists+linux-fscrypt@lfdr.de>; Sat, 24 Jul 2021 09:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhGXGjM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 24 Jul 2021 02:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhGXGjK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 24 Jul 2021 02:39:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EB9C061575;
        Sat, 24 Jul 2021 00:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O/XU7BaOJ1uvC1EkMCQUlQz3U2U8xvRd2MbfcwD2IpA=; b=MDgreUOWODAfOvefRAPYEl3Oia
        dHU4LYmu8cbdWaaqhowrU9J6cLhO6rLSUkrKQy0hsdL3ePEwcProggNMwZU75a92cRzyw6YUByyPQ
        5Y9tgXQqRw4Dlqh6wGhbGvJGcbVMxiFloSSZdc4WjU1y9Z0a0eStaG+OMLSPdiTV1bn6NuTRM9ZDF
        xUDXHwdc8arrh21Zj74m9ppkAhoqn0v6yJpyIxNTnNmDMOjsSClzfb7I+oUFSrsBHY15IW2yzWR66
        XSg8y9K9nagTX9+/MW2gvdnz6aUoY0TbQxc1iUbHC92XmfQd0Tym2t+KeBL/HI4T3iAfcR6zWo6OI
        ElGynbeA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7BwJ-00C4tG-OZ; Sat, 24 Jul 2021 07:19:17 +0000
Date:   Sat, 24 Jul 2021 08:19:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Satya Tangirala <satyat@google.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v9 5/9] block: Make bio_iov_iter_get_pages() respect
 bio_required_sector_alignment()
Message-ID: <YPu+88KReGlt94o3@infradead.org>
References: <20210604210908.2105870-1-satyat@google.com>
 <20210604210908.2105870-6-satyat@google.com>
 <YPs1jlAsvXLomSJJ@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPs1jlAsvXLomSJJ@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 23, 2021 at 02:33:02PM -0700, Eric Biggers wrote:
> I do still wonder if we should just not support that...  Dave is the only person
> who has asked for it, and it's a lot of trouble to support.
> 
> I also noticed that f2fs has always only supported direct I/O that is *fully*
> fs-block aligned (including the I/O segments) anyway.  So presumably that
> limitation is not really that important after all...
> 
> Does anyone else have thoughts on this?

There are some use cases that really like sector aligned direct I/O,
what comes to mind is some data bases, and file system repair tools
(the latter on the raw block device).  So it is nice to support, but not
really required.

So for now I'd much prefer to initially support inline encryption for
direct I/O without that if that simplifies the support.  We can revisit
the additional complexity later.

Also note that for cheap flash media pretending support for 512 byte
blocks is actually a bit awwkward, so just presenting the media as
having 4096 sectors in these setups would be the better choice anyway.
