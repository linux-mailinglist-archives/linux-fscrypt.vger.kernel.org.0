Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3B0284870
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Oct 2020 10:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgJFIXJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 6 Oct 2020 04:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgJFIXI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 6 Oct 2020 04:23:08 -0400
Received: from coco.lan (ip5f5ad5bd.dynamic.kabel-deutschland.de [95.90.213.189])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA95F20866;
        Tue,  6 Oct 2020 08:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601972587;
        bh=aUjnNOobAIUP4yMNBV8z5ZaoFW5PaJzxv4cfACCT6yw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=osWuobD8IUB7+qfnWOqsvp/hUw2/tiMt1APrcuxKI/Pez1x6fhh90ocp6VXRw/a5k
         rJQcbVkhHcA11v2195gjwKq9hlJj3mDQX1AWtWxuq38xVb6DOrOZY77Uc6+d19Tnoe
         klo+5Aeq9F22QHse91/HIdPwiNn/zCsQ4jFsFZjk=
Date:   Tue, 6 Oct 2020 10:23:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 35/52] docs: fs: fscrypt.rst: get rid of :c:type:
 tags
Message-ID: <20201006102301.67649c4d@coco.lan>
In-Reply-To: <20201005190823.GB3128920@gmail.com>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
        <689d790237b64fc7d81fcf97ac303cc1dbdd33d4.1601467849.git.mchehab+huawei@kernel.org>
        <20200930162144.GA9698@sol.localdomain>
        <20200930185333.66dacbc6@coco.lan>
        <20200930170637.GB9698@sol.localdomain>
        <20201005140622.50693933@coco.lan>
        <20201005190823.GB3128920@gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Em Mon, 5 Oct 2020 12:08:23 -0700
Eric Biggers <ebiggers@kernel.org> escreveu:

> On Mon, Oct 05, 2020 at 02:06:22PM +0200, Mauro Carvalho Chehab wrote:
> > The latest version at:
> > 
> > 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=sphinx3-fixes-v4  
> 
> Doesn't work either.
> 
> $ git remote add mchehab https://git.linuxtv.org/mchehab/experimental.git
> $ git fetch mchehab
> warning: alternate disabled by http.followRedirects: https://git.linuxtv.org/git/linux.git/
> warning: alternate disabled by http.followRedirects: https://git.linuxtv.org/git/media_tree.git/
> warning: alternate disabled by http.followRedirects: https://git.linuxtv.org/git/linux.git/
> error: Unable to find 4d9f4b7b8bf7af2d8deb4435833a7e165b9bdd21 under https://git.linuxtv.org/mchehab/experimental.git
> Fetching objects: 286, done.
> Cannot obtain needed object 4d9f4b7b8bf7af2d8deb4435833a7e165b9bdd21
> while processing commit 0a0cde580853340e1a585a1959eaaf055b7cff9a.
> error: fetch failed.

Well, support for https was broken at linuxtv.org. Not many media
developers use https instead of git.

The main issue is that we heavily use alternates there, in order
to minimize disk space usage. After some server upgrade, https
stopped working properly.

I just fixed it, by adding some new rewrite rules that will call
git http-backend in order to solve alternates.

Thanks for reporting it.

> > In the specific case of fscript.rst, there are only two patches on my
> > series affecting it, both as part of this /52 series:  
> 
> But those two patches don't apply because they also change other files.
> 
> I need to apply patches to do a proper review.  Reviewers shouldn't have to
> waste time trying to figure out how to apply your patches.

Yeah, agreed. Sorry for that. 

Not sure what would be the best way to minimize the issues, though.

I mean, I might place those documentation patches on my linux-next
branch, making them visible at tomorrow's linux-next, but that
doesn't sound a good idea, as this will be a source of conflicts,
since several patches from my tree are based on patches applied
via someone's else's tree.

Hopefully, after getting this series merged upstream, the
docs build for html will finally went into a clean state. Any new
warnings that might sleep though maintainer's reviews could
easily be fixed without depending on a 100+ patch series.

-

Btw, there was no new linux-next tag yesterday. The last one is
still next-20201002.

I'll wait for a while a today's linux-next. After rebasing on the
top of that, I'll submit a v5 of this series.

Thanks,
Mauro
