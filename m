Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59B31599A0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 20:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgBKTWM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Feb 2020 14:22:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729800AbgBKTWM (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Feb 2020 14:22:12 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC4720842;
        Tue, 11 Feb 2020 19:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581448931;
        bh=WzUwKnGn5n0Q+3tuucRPgAJqJjTBQCGNMXNs0Zg5DH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BLW8nfwuIZfwnQFggGhfG2VTU0eqiywJSQZsMERxSDD2LdIcOSa3jv5fWONPIZU5e
         Zz1JbAQONuXrPe2Ezz6kZLzC1qxSYNYJ3TkhhkuPv+IdTSricahoSSw50IdRXxeV7i
         q5433LH/1ceTACKH5kv4osiFdIXUJSSz2/I+oKd4=
Date:   Tue, 11 Feb 2020 11:22:09 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
Message-ID: <20200211192209.GA870@sol.localdomain>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Jes,

On Mon, Feb 10, 2020 at 07:00:30PM -0500, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Hi,
> 
> I am looking at what it will take to add support for fsverity
> signatures to rpm, similar to how rpm supports IMA signatures.
> 
> In order to do so, it makes sense to split the fsverity util into a
> shared library and the command line tool, so the core functions can be
> used from other applciations. Alternatively I will have to copy over a
> good chunk of the code into rpm, which makes it nasty to support long
> term.
> 
> This is a first stab at doing that, and I'd like to get some feedback
> on the approach.
> 
> I basically split it into four functions:
> 
> fsverity_cmd_gen_digest(): Build the digest, but do not sign it
> fsverity_cmd_sign():       Sign the digest structure
> fsverity_cmd_measure():    Measure a file, basically 'fsverity measure'
> fsverity_cmd_enable():     Enable verity on a file, basically 'fsverity enable'
> 
> If we can agree on the approach, then I am happy to deal with the full
> libtoolification etc.
> 

Before we do all this work, can you take a step back and explain the use case so
that we can be sure it's really worthwhile?

fsverity_cmd_enable() and fsverity_cmd_measure() would just be trivial wrappers
around the FS_IOC_ENABLE_VERITY and FS_IOC_MEASURE_VERITY ioctls, so they don't
need a library.  [Aside: I'd suggest calling these fsverity_enable() and
fsverity_measure(), and leaving "cmd" for the command-line wrappers.] 

That leaves signing as the only real point of the library.  But do you actually
need to be able to *sign* the files via the rpm binary, or do you just need to
be able to install already-created signatures?  I.e., can the signatures instead
just be created with 'fsverity sign' when building the RPMs?

Separately, before you start building something around fs-verity's builtin
signature verification support, have you also considered adding support for
fs-verity to IMA?  I.e., using the fs-verity hashing mechanism with the IMA
signature mechanism.  The IMA maintainer has been expressed interested in that.
If rpm already supports IMA signatures, maybe that way would be a better fit?

- Eric
