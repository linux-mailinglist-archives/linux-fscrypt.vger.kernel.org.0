Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D232CD821
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Dec 2020 14:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgLCNqw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Dec 2020 08:46:52 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52366 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725966AbgLCNqv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Dec 2020 08:46:51 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0B3DjdIr014834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 3 Dec 2020 08:45:40 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 58FF3420136; Thu,  3 Dec 2020 08:45:39 -0500 (EST)
Date:   Thu, 3 Dec 2020 08:45:39 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Satya Tangirala <satyat@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v7 6/8] ext4: support direct I/O with fscrypt using
 blk-crypto
Message-ID: <20201203134539.GB441757@mit.edu>
References: <20201117140708.1068688-1-satyat@google.com>
 <20201117140708.1068688-7-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117140708.1068688-7-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 17, 2020 at 02:07:06PM +0000, Satya Tangirala wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Wire up ext4 with fscrypt direct I/O support. Direct I/O with fscrypt is
> only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
> have been enabled, the 'inlinecrypt' mount option must have been specified,
> and either hardware inline encryption support must be present or
> CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
> direct I/O on encrypted files is only supported when the *length* of the
> I/O is aligned to the filesystem block size (which is *not* necessarily the
> same as the block device's block size).
> 
> fscrypt_limit_io_blocks() is called before setting up the iomap to ensure
> that the blocks of each bio that iomap will submit will have contiguous
> DUNs. Note that fscrypt_limit_io_blocks() is normally a no-op, as normally
> the DUNs simply increment along with the logical blocks. But it's needed
> to handle an edge case in one of the fscrypt IV generation methods.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Co-developed-by: Satya Tangirala <satyat@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>
> Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>

Acked-by: Theodore Ts'o <tytso@mit.edu>

