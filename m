Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CB62A18FE
	for <lists+linux-fscrypt@lfdr.de>; Sat, 31 Oct 2020 18:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgJaRep (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 31 Oct 2020 13:34:45 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:43581 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725497AbgJaRep (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 31 Oct 2020 13:34:45 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 09VHYem5024883
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Oct 2020 13:34:40 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DB499420107; Sat, 31 Oct 2020 13:34:39 -0400 (EDT)
Date:   Sat, 31 Oct 2020 13:34:39 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] generic/395: remove workarounds for wrong error codes
Message-ID: <20201031173439.GA1750809@mit.edu>
References: <20201031054018.695314-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031054018.695314-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Oct 30, 2020 at 10:40:18PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> generic/395 contains workarounds to allow for some of the fscrypt ioctls
> to fail with different error codes.  However, the error codes were all
> fixed up and documented years ago:
> 
> - FS_IOC_GET_ENCRYPTION_POLICY on ext4 failed with ENOENT instead of
>   ENODATA on unencrypted files.  Fixed by commit db717d8e26c2
>   ("fscrypto: move ioctl processing more fully into common code").
> 
> - FS_IOC_SET_ENCRYPTION_POLICY failed with EINVAL instead of EEXIST
>   on encrypted files.  Fixed by commit 8488cd96ff88 ("fscrypt: use
>   EEXIST when file already uses different policy").
> 
> - FS_IOC_SET_ENCRYPTION_POLICY failed with EINVAL instead of ENOTDIR
>   on nondirectories.  Fixed by commit dffd0cfa06d4 ("fscrypt: use
>   ENOTDIR when setting encryption policy on nondirectory").
> 
> It's been long enough, so update the test to expect the correct behavior
> only, so we don't accidentally reintroduce the wrong behavior.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

LGTM

Did these fixes get backported into the stable kernels (and the
relevant Android trees)?

						- Ted
