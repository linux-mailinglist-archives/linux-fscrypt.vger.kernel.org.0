Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A231E1EB04E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2020 22:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgFAUgt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 1 Jun 2020 16:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbgFAUgt (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 1 Jun 2020 16:36:49 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6C5E206E2;
        Mon,  1 Jun 2020 20:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591043808;
        bh=CL6n3OwtP/pZ1fmLjKPMkaNLKUxQySOPZPZF1c4goOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=09+XyoE7wWJzdzkVj/l+4tkDzR22JNqkIQqpnkv+Pp9xmMyGlQykGe9gWJYHcrcxK
         56vBQba6MmTRk0lb+w1WNsjhYH4sGN71FfED38Mw4yLxlet+YOz5SDs7ih7iiOuWyf
         KjputpUwJif6D/P6fGTBJ69ePTWUG8DjOMUBcmpY=
Date:   Mon, 1 Jun 2020 13:36:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Chris Mason <clm@fb.com>
Subject: Re: fsverity PAGE_SIZE constraints
Message-ID: <20200601203647.GB168749@gmail.com>
References: <69713333-8072-adf0-a6bb-8f73b3c390d0@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69713333-8072-adf0-a6bb-8f73b3c390d0@trained-monkey.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jun 01, 2020 at 04:13:45PM -0400, Jes Sorensen wrote:
> Hi,
> 
> I am working on adding fsverity support to RPM and I am hitting a tricky
> problem. I am see this with RPM, but it really isn't specific to RPM,
> and will apply to any method for distribution signatures.
> 
> fsverity is currently hard-wiring the Merkle tree block size to
> PAGE_SIZE. This is problematic for a number of reasons, in particular on
> architectures that can be configured with different page sizes, such as
> ARM, as well as the case where someone generates a shared 'common'
> package to be used cross architectures (noarch package in RPM terms).
> 
> For a package manager to be able to create a generic package with
> signatures, it basically has to build a signature for every supported
> page size of the target architecture.
> 
> Chris Mason is working on adding fsverity support to btrfs, and I
> understand he is supporting 4K as the default Merkle tree block size,
> independent of the PAGE_SIZE.
> 
> Would it be feasible to make ext4 and other file systems support 4K for
> non 4K page sized systems and make that a general recommendation going
> forward?
> 

It's possible, but it will be a little difficult.  We made a similar
simplification for ext4 encryption initially, and it took a long time to remove
it.  (ext4 encryption was first supported in Linux v4.1.  ext4 encryption didn't
support block_size != PAGE_SIZE until Linux v5.5, following work by
Chandan Rajendra and myself.)

Fixing this would require a number of different changes:

- Updating fscrypt_verify_bio() and fsverity_verity_page() to iterate through
  all data blocks in each page, and to handle sub-page Merkle tree blocks

- Defining a mechanism other than PageChecked to mark Merkle tree blocks as
  verified.  E.g., allocating an in-memory bitmap as part of the struct
  fsverity_info.  This should also be optional, in the sense that we shouldn't
  use the memory for it when it's not needed.

- Supporting fs-verity in block_read_full_page() in fs/buffer.c.

There may be other changes needed too; those are just the obvious ones.

Is this something that you or Chris is interested in working on?

- Eric
