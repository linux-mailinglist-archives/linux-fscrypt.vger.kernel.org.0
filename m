Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4EF2DC731
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Dec 2020 20:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388798AbgLPTdM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Dec 2020 14:33:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388790AbgLPTdL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:11 -0500
Date:   Wed, 16 Dec 2020 11:18:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608146323;
        bh=iCVKvT8AM7hQjZm6wOvuriR9MvxAg3zV7N5vIhBm4qA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=oaobSmxZijY8XI7WPdMsEmnrPBZ7uPOLoRDQcXSe4cDy2J8WHj/5qo6UZUtBBaUfl
         siaHiG5LGGA1epo7vN1mEgQn0qxv5w2d0ldkmgsSpXryQaQBIlle6ioBDce8uT36eb
         vg4WxdEMZVAevSzqQUtrbGqZG37uENal/J6O7ejNVvTG1I27koTn7OIJcuMukOmwte
         6eGGUxwkzQZziIqH+eZKxwYwIXfkwalY+6u/Guh06ugaDPqjBzOk83I6cOmPfR+sIv
         dSrhyb0MAGfPQVWq6GFgfu/8N6fiMiEn1B0QFi0PkfCcLWenB5Ead0WwFenpr/+4dl
         FZetpu/Kv24Hw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH 2/2] Allow to build and run sign/digest on
 Windows
Message-ID: <X9pdkXty2uoLJG4R@sol.localdomain>
References: <20201216172719.540610-1-luca.boccassi@gmail.com>
 <20201216172719.540610-2-luca.boccassi@gmail.com>
 <X9pbQjFDwr/Vd0/O@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9pbQjFDwr/Vd0/O@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 16, 2020 at 11:08:51AM -0800, Eric Biggers wrote:
> > +#ifndef _WIN32
> >  		if (asprintf(&msg2, "%s: %s", msg,
> >  			     strerror_r(err, errbuf, sizeof(errbuf))) < 0)
> > +#else
> > +		strerror_s(errbuf, sizeof(errbuf), err);
> > +		if (asprintf(&msg2, "%s: %s", msg, errbuf) < 0)
> > +#endif
> >  			goto out2;
> 
> Instead of doing this, could you provide a strerror_r() implementation in
> programs/utils.c for _WIN32?
> 

Actually it would be lib/utils.c, not programs/utils.c.

- Eric
