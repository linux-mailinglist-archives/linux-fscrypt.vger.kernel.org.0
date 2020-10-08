Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950492873FD
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Oct 2020 14:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgJHMZN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Oct 2020 08:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729665AbgJHMZM (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Oct 2020 08:25:12 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2959217BA;
        Thu,  8 Oct 2020 12:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602159912;
        bh=UfpNWK7XOOg3ND9gxamY9z2qobCu079EX+CjN7GjcWI=;
        h=Subject:From:To:Cc:Date:From;
        b=yAICn52PWfuqFq1cGfp521epESUzMKoayIRmKd8qjooUERXhgMbAcHJxiUCS36zEH
         BcKoJtkP9Rik0fnu7So3zef9PZCfIAOA7P1qv5miYJbWf1YM8faqGi0ZvdTbb0I/Ay
         JmKDMGJhrrf2CJevT4yCYmYgNNJpWq8M+/M+3R60=
Message-ID: <24943af8b2ede65d5ff1c8ff78c7a00b914e1a20.camel@kernel.org>
Subject: fscrypt, i_blkbits and network filesystems
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>
Date:   Thu, 08 Oct 2020 08:25:10 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

I've had to table the work on fscrypt+ceph for a bit to take care of
some other issues, but I'm hoping to return to it soon, and I've started
looking at the content encryption in more detail.

One thing I'm not sure how to handle yet is fscrypt's reliance on
inode->i_blkbits. For ceph (and most netfs's), this value is a fiction.
We're not constrained to reading/writing along block boundaries.

Cephfs usually sets the blocksize in a S_ISREG inode to the same as a
"chunk" on the OSD (usu. 4M). That's a bit too large to deal with IMO,
so I'm looking at lowering that to PAGE_SIZE when fscrypt is enabled.

That's reasonable when we can do pagecache-based I/O, but sometimes
netfs's will do I/O directly from read_iter/write_iter. For ceph, we may
need to do a rmw cycle if the iovec passed down from userland doesn't
align to crypto block boundaries. Ceph has a way to do a cmp_extent
operation such that it will only do the write if nothing changed in the
interim, so we can handle that case, but it would be better not to have
to read/write more than we need.

For the netfs case, would we be better off avoiding routines that take
i_blkbits into account, and instead just work with
fscrypt_encrypt_block_inplace / fscrypt_decrypt_block_inplace, maybe
even by rolling new helpers that call them under the hood? Or, would
that cause issues that I haven't forseen, and I should just stick to
PAGE_SIZE blocks?

Thoughts?
-- 
Jeff Layton <jlayton@kernel.org>

