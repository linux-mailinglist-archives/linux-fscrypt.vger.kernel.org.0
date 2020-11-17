Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BB52B6B85
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 18:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgKQRQA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 12:16:00 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:53457 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727641AbgKQRP7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 12:15:59 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0AHHFQSN025997
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 12:15:27 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 611CD420107; Tue, 17 Nov 2020 12:15:26 -0500 (EST)
Date:   Tue, 17 Nov 2020 12:15:26 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Satya Tangirala <satyat@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 0/8] add support for direct I/O with fscrypt using
 blk-crypto
Message-ID: <20201117171526.GD445084@mit.edu>
References: <20201117140708.1068688-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117140708.1068688-1-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

What is the expected use case for Direct I/O using fscrypt?  This
isn't a problem which is unique to fscrypt, but one of the really
unfortunate aspects of the DIO interface is the silent fallback to
buffered I/O.  We've lived with this because DIO goes back decades,
and the original use case was to keep enterprise databases happy, and
the rules around what is necessary for DIO to work was relatively well
understood.

But with fscrypt, there's going to be some additional requirements
(e.g., using inline crypto) required or else DIO silently fall back to
buffered I/O for encrypted files.  Depending on the intended use case
of DIO with fscrypt, this caveat might or might not be unfortunately
surprising for applications.

I wonder if we should have some kind of interface so we can more
explicitly allow applications to query exactly what the requirements
might be for a particular file vis-a-vis Direct I/O.  What are the
memory alignment requirements, what are the file offset alignment
requirements, what are the write size requirements, for a particular
file.

						- Ted
