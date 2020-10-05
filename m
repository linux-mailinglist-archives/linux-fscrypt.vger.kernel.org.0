Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33A1283F4E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Oct 2020 21:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgJETI0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Oct 2020 15:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgJETI0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Oct 2020 15:08:26 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5527520644;
        Mon,  5 Oct 2020 19:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601924905;
        bh=9z6ZaTxBLhsA1wnVdNrw7GMX0svcJnly+OPiK3hDWyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ndm4eZjeatJk7b2vzoN/fInslO6xJ9Fvo+Pfhbsr56QRHVmP4DkrIVBh1EXA9u6nK
         56+YHOdrC3JYI6rqLD2nW6E8we9P4bZsLNytKLfpSuKi1lS6a0DiHYDLz+edR0e1k9
         oK3p6pxyswjBS1wf6M8jWg3xHSYFm+H/VoPOYmeE=
Date:   Mon, 5 Oct 2020 12:08:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 35/52] docs: fs: fscrypt.rst: get rid of :c:type: tags
Message-ID: <20201005190823.GB3128920@gmail.com>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
 <689d790237b64fc7d81fcf97ac303cc1dbdd33d4.1601467849.git.mchehab+huawei@kernel.org>
 <20200930162144.GA9698@sol.localdomain>
 <20200930185333.66dacbc6@coco.lan>
 <20200930170637.GB9698@sol.localdomain>
 <20201005140622.50693933@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005140622.50693933@coco.lan>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 05, 2020 at 02:06:22PM +0200, Mauro Carvalho Chehab wrote:
> The latest version at:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=sphinx3-fixes-v4

Doesn't work either.

$ git remote add mchehab https://git.linuxtv.org/mchehab/experimental.git
$ git fetch mchehab
warning: alternate disabled by http.followRedirects: https://git.linuxtv.org/git/linux.git/
warning: alternate disabled by http.followRedirects: https://git.linuxtv.org/git/media_tree.git/
warning: alternate disabled by http.followRedirects: https://git.linuxtv.org/git/linux.git/
error: Unable to find 4d9f4b7b8bf7af2d8deb4435833a7e165b9bdd21 under https://git.linuxtv.org/mchehab/experimental.git
Fetching objects: 286, done.
Cannot obtain needed object 4d9f4b7b8bf7af2d8deb4435833a7e165b9bdd21
while processing commit 0a0cde580853340e1a585a1959eaaf055b7cff9a.
error: fetch failed.

> In the specific case of fscript.rst, there are only two patches on my
> series affecting it, both as part of this /52 series:

But those two patches don't apply because they also change other files.

I need to apply patches to do a proper review.  Reviewers shouldn't have to
waste time trying to figure out how to apply your patches.

- Eric
