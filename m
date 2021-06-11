Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C843A39CC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Jun 2021 04:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFKCeg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Jun 2021 22:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhFKCeg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Jun 2021 22:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EBB8610A2;
        Fri, 11 Jun 2021 02:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623378759;
        bh=OrNUG3+bO1ZJjg7MHhV1jfjvj4Q9wI4gAr5OYMGOLec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QwaFQgEk3jXzBh/nFboF4QPY8LbZ2iJMuIIWOnNfg9pRtJFReJRFf4eUjo4TFXtZQ
         S/f6EqhlZbazOupUCH0Sns3igyy/eMXFitj5ZvEVubxA8DIPHJDJasDTtiWM5/X8LN
         iVTh2UTjvBVRZf6JAe5QRXxv+yi7WUCj++6UlYua7c3sRfEHfCFVXJQicwTIcS0zl5
         VY5ubUSQhfpP9fqe62IfF5ffeFM70RbW7GfeQYtFgQ7dXbyqdV5OEQbchOqPauh1lS
         vBpuk19czL2vEy0y4nSpS9ubd/W9mnjccPiGUvRoWXmpY8JnV3J1eTySuccBnEyd3u
         Q2+ES/PaJzSlg==
Date:   Thu, 10 Jun 2021 19:32:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Luca Boccassi <bluca@debian.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH] Add man page for fsverity
Message-ID: <YMLLRRW/lxggRPYQ@sol.localdomain>
References: <20210610072056.35190-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610072056.35190-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 10, 2021 at 12:20:56AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a manual page for the fsverity utility, documenting all subcommands
> and options.
> 
> The page is written in Markdown and is translated to groff using pandoc.
> It can be installed by 'make install-man'.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  .gitignore            |   1 +
>  Makefile              |  32 ++++++-
>  README.md             |  14 +++-
>  man/fsverity.1.md     | 191 ++++++++++++++++++++++++++++++++++++++++++
>  scripts/do-release.sh |   6 ++
>  scripts/run-tests.sh  |   2 +-
>  6 files changed, 239 insertions(+), 7 deletions(-)
>  create mode 100644 man/fsverity.1.md

Applied.

- Eric
