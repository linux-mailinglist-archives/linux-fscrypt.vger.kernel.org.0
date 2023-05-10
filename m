Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C326FD6F0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 May 2023 08:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjEJGYZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 10 May 2023 02:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjEJGYY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 10 May 2023 02:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8705D49D0
        for <linux-fscrypt@vger.kernel.org>; Tue,  9 May 2023 23:23:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 306EC63847
        for <linux-fscrypt@vger.kernel.org>; Wed, 10 May 2023 06:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FF4C433EF;
        Wed, 10 May 2023 06:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683699819;
        bh=hBO4jHlUXNONGKxTf6ICbdnfNzd8YEWX6q6eIUsVCT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R9e45P+oVlyFbjo87bg/jBlys9HDjQKRVEDDMUYCqXp7qGW5H6Eaunkgj3+u/aWok
         gmX4PfvbyZtojUY/PMyY18W0CX0zezKGxzsFiJ70P8IHTN+28CrFhT7JMjm9HH9KY3
         FAmWMhdFjFy37MoFoYVE+RMyoIW1bkEOlhK04ICbEJTH8kGI/Ud064SCFnZTAzFRqt
         G0iU5dKmLFVwWru2eL8FSNCSI4hHlzCUIHwi272dSfGPvW9EePTlIx4E8e3xK90X7/
         GNAl6/SeUoBu/gMzXiIGQPJuzEuLSETsxrt/yj6yGG2u6m8DrlJbhFhlOOn+6mHR/u
         fEsJiT/SDgM+A==
Date:   Tue, 9 May 2023 23:23:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Paul Gover <pmw.gover@yahoo.co.uk>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org
Subject: Re: fscrypt - Bug or Feature - mv file from encrypted to
 nonencrypted folder?
Message-ID: <20230510062337.GB1851@quark.localdomain>
References: <3234925.aeNJFYEL58.ref@hp>
 <3234925.aeNJFYEL58@hp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3234925.aeNJFYEL58@hp>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Paul,

On Tue, May 09, 2023 at 03:26:34PM +0100, Paul Gover wrote:
> Apologies if this should be raised as an issue in git, or if it's been 
> discussed already (if so, I couldn't find it - I did try).
> 
> Moving a file (mv) from an encrypted folder to a non-encrypted folder exhibits 
> surprising behaviour.  The moved file is readable if the owner of the 
> encrypted folder is signed in.  If not, you get a useless error message.
> 
> In my case, filesystem F2FS, "packager"'s home directory is encrypted using 
> fscrypt and unlocked with the login password for "packager" as per fscrypt 
> documentation.
> 
> The path to and including /usr/local/bin is not encrypted - only various home 
> directories.
> 
> I have ~packager/test.file containing a line of text.
> Signed in as packager:
> 	cp test.file /usr/local/bin/test.file.copied
> 	mv test.file /usr/local/bin/test.file.moved
> Logged in on another tty as "paul", while packager is still logged in,
> I can cat both files in /usr/local/bin and see the text as expected.
> When packager logs out, however,
> "cat /usr/local/bin/test.file.copied"  produces the expected text.
> "cat /usr/local/bin/tes.file.moved"   produces
> 	"cat: test.file.moved: Required key not available"
> Sadly, it does not explain which key is required!
> 
> This is on kernel 6.3.1, compiled with Clang and LTO=thin, on a Gentoo system, 
> but I'd hope that was irrelevant.
> 
> I see similar issues have already been discussed, for example:
> //lore.kernel.org/linux-fscrypt/20201031183551.202400-1-ebiggers@kernel.org/#r
> "fscrypt: return -EXDEV for incompatible rename or link into encrypted dir".
> 
> //github.com/google/fscrypt/issues/124
> "Document mv behavior when using filesystem encryption" ought to cover the 
> case, but doesn't warn of the potential for confusion.
> 
> My own thoughts on this: (a) I should have used "install" to copy the program 
> in question into /usr/local/bin! but (b) the current situation is very 
> confusing.  I ran a test with "ln", and note that trying to create a hard link 
> in an encrypted directory to a file in an unencrypted one:
> "link foo /usr/local/bin/target" fails with "Invalid cross-device link".
> This seems to be desirable behaviour for the case of:
> "mv foo /usr/local/bin", or alternatively treat it like a cross-device move, 
> and instead do a copy.

This is working as intended.  Unencrypted directories are allowed to contain
encrypted files.  It's only the other way around -- unencrypted files in
encrypted directories -- that is not allowed.  So, renaming an encrypted file
into an unencrypted directory succeeds.

I can understand how this can seem unexpected, but unencrypted directories do
need to be able to contain encrypted directories, after all; otherwise nothing
could ever be encrypted in the first place.  The current behavior then results
just from not treating directories specially, and just doing exactly what the
user asked to do -- rename the given file.

As for the "Required key not available" error message not telling you which key
is meant, that's simply because the kernel only reports integer error codes
(ENOKEY in this case).  We can't do anything about that.

- Eric
