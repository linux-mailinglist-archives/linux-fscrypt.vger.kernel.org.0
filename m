Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B645D2ACE99
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Nov 2020 05:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbgKJEli (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Nov 2020 23:41:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbgKJElh (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Nov 2020 23:41:37 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 610B2206B6;
        Tue, 10 Nov 2020 04:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604983297;
        bh=VDADBIQU8MLhJESJ/oASxtoZyu+l/Vyn9yb8+9Nfe/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jXgI0r8YEFow/BZwWeo20kxuxQzgvDls907DcysrYEWwvdWx5DEUa5Bzc04uWGHFa
         n0+uGawwvXwjAs26b5/p8bM391KWMdghErlq0SR/notsLlEC0u4oXoJSmb09qKAxhn
         ovtYJV6EAab48YelxsWNx7Zqboug/UaH3Pee47AI=
Date:   Mon, 9 Nov 2020 20:41:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] generic/395: remove workarounds for wrong error codes
Message-ID: <20201110044136.GD853@sol.localdomain>
References: <20201031054018.695314-1-ebiggers@kernel.org>
 <20201031173439.GA1750809@mit.edu>
 <20201031181048.GA936@sol.localdomain>
 <20201109234051.GC853@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109234051.GC853@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 09, 2020 at 03:40:51PM -0800, Eric Biggers wrote:
> 
> I ended up backporting some of the missing patches to some of the LTS kernels.
> 
> Now the status of the "encrypt" group tests is:
> 
> 5.10-rc3: all pass, but generic/602 is flaky on ext4, which will be fixed by
>           https://lkml.kernel.org/linux-fscrypt/20201109231151.GB853@sol.localdomain
> 
> 5.4: all pass.
> 

Correction: there are two more test failures on upstream and on 5.4.
generic/580 fails on f2fs due to the lazytime bug
(https://lkml.kernel.org/r/20200306004555.GB225345@gmail.com), and generic/595
fails on ubifs due to a longstanding race condition where a file can be created
using a negative "no-key" dentry.  I'm planning to fix these.

- Eric
