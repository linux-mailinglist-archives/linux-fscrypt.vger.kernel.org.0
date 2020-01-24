Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35A214779F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Jan 2020 05:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgAXEbD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 23 Jan 2020 23:31:03 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37394 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729316AbgAXEbD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 23 Jan 2020 23:31:03 -0500
Received: by mail-lj1-f193.google.com with SMTP id v17so924585ljg.4
        for <linux-fscrypt@vger.kernel.org>; Thu, 23 Jan 2020 20:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YARMc3ae9hSUEoLGMas34bGpYXx9jRcQkvor0pcL47o=;
        b=KDHO7h9B/b3mjy26Oj4EeSJIUNyQLYKaSj3d1nBNy4K7dVvqvhrzQt3G+uksHtglCC
         GEn7l0fqTV7YiLooSM8wJDBDZ3zMa1NiXyT+I4cRb1BWaZgPHz2JpFTvojB+HO94ozad
         MFaWKBQ9Zo4BEUhjLXI4paXN7kyNHtoN96Dwri5CF7MjQQUEfySc0AQBNxyC2R8iJZCg
         guQxm94eI0DXd65SS/rnuHoJaoHhIN0BgEW5d7+6uC/9ey1p7B8TnBe/F7DCn8v2dGTO
         IOVEJ7yvZF/HCRcAWrK9qPC6Itzo8kSjahJNwMYca4x2RJsn6vyrLjbauzKhHQ8haKAe
         U9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YARMc3ae9hSUEoLGMas34bGpYXx9jRcQkvor0pcL47o=;
        b=Xfk2rXgnZR+kfbYK7AMDk14ViBchk3tiZyZeiAQou3W60HXjgCaAWShgH/7FE6/RvJ
         K92qr55c38DhuTzMwU/DScbLacSIZN2Bt2dEYNkY9lJF3rn8G1gFH0+fKNfuvw30sV6a
         eBjNyi1KLvfPi0K706eqblQ3J6qHLk0kOmJf1N5aTQc4wPxgu3KMGs4kP2ICM0mWvx3B
         jjPQgVwpj6ubMKoeybticWqh1GAf0A2/W65qTOXuBFVbhzx8ciZxFqxjJMQZfqg91K/q
         HF3jq4M0MF9zGGADRB7TYiO47RDMtgOMeqYK2idalZCW4IOpJwl7rSq3ETeguKXfA6vk
         FwIg==
X-Gm-Message-State: APjAAAWWgtCypubZBy0/OiOS3R/Tf5v0Pz3F00nlBWU/1InCGDomUvpO
        OYPVyIwLfAU9e9Wmn+laGIyjRAsRGfcp/74B6fUn2w==
X-Google-Smtp-Source: APXvYqxDuXJqv/c/SqXLq4l0cAQvIWw6dIaAJm1RLNe4FSj10K4FMOIdAwv3/v/qIrOL5GnNI2cG/1NfCFFst9nvTGM=
X-Received: by 2002:a2e:7816:: with SMTP id t22mr1024528ljc.161.1579840260417;
 Thu, 23 Jan 2020 20:31:00 -0800 (PST)
MIME-Version: 1.0
References: <20200117214246.235591-1-drosen@google.com> <20200117214246.235591-6-drosen@google.com>
 <20200120013528.GY8904@ZenIV.linux.org.uk>
In-Reply-To: <20200120013528.GY8904@ZenIV.linux.org.uk>
From:   Daniel Rosenberg <drosen@google.com>
Date:   Thu, 23 Jan 2020 20:30:49 -0800
Message-ID: <CA+PiJmQPFG7OehStFfNQE_7MGwgozhaa0TxZd+aHL2cFLMFbsA@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] vfs: Fold casefolding into vfs
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

> ... buggering the filesystems (and boxen) that never planned to use
> that garbage.
>
I'm planning to rework this as dentry ops again. Your other comments
point out some issues that also exist in the old dentry_operations, so
that's a good opportunity to fix those up. How do you feel about just
having the two entries in struct super_block? With them there, I can
add the dentry_operations to fs/unicode where they won't bother anyone
else, while not making every filesystem that uses it have to carry
near identical code.

>
> Are you serious?
>         1) who said that ->d_inode is stable here?  If we are in RCU mode,
> it won't be.
>         2) page-sized kmalloc/kfree *ON* *COMPONENT* *AFTER* *COMPONENT*?
>

#2 is the part that made me the saddest in the patch. I'm planning to
move this to the unicode subsystem so it can just walk through the
name as it computes the hash without needing any allocation.

>
> ... and again, you are pulling in a lot of cachelines.
>

I probably should've just given it a DCACHE flag, like what fscrypt is
using. A simple flag there would've done everything that I'm doing
without making the cache super sad and making any attempts at making
it actually work with RCU much simpler.

> <understatement> IMO the whole thing is not a good idea. </understatement>
