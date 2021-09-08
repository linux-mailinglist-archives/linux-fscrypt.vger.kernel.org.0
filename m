Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6649A40412C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 00:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241622AbhIHWpq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Sep 2021 18:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhIHWpp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Sep 2021 18:45:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D893610A3;
        Wed,  8 Sep 2021 22:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631141077;
        bh=TDOpX/cAF+C/UvOYoJMq5CgyT3JXypmnhWy9HvP3ET8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QxLGaxgoYYrhuJUQew/t3ScbVgLiB6oT7w6CF9YV8nssEH9srmgsY12jDIQxUadPR
         2alBo8p2x7G73rnAFZ5tIWI4/K0NvjwsKU5gWjDeSohls4WgQ7jLtHrIWr5HxSz/NS
         jufWLr3oWlmCd5TXXLidX9Zudvkl5zmPrQ5ijEp8zgT2WZVG0BwqdjoFsrwRkVlEoi
         AbXuwTvn1Rzkix33s+nNJ6ugIQm4dIXvZXIRFLfmdWHzjoq0EOz6HdsCu/R3uLWTRk
         x+WRqcevlt5HOlKCq6z/AwCQ7p+G0sK3dKQFO0kSfAVrVrTLePN4hfYL44M6zQ/wMv
         aJHat/DTp8tng==
Date:   Wed, 8 Sep 2021 15:44:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Aleksander Adamowski <olo@fb.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v2] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Message-ID: <YTk806ahPPcuz9gl@gmail.com>
References: <20210828013037.2250639-1-olo@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828013037.2250639-1-olo@fb.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Aug 27, 2021 at 06:30:37PM -0700, Aleksander Adamowski wrote:
> PKCS#11 API allows us to use opaque keys confined in hardware security
> modules (HSMs) and similar hardware tokens without direct access to the
> key material, providing logical separation of the keys from the
> cryptographic operations performed using them.
> 
> This commit allows using the popular libp11 pkcs11 module for the
> OpenSSL library with `fsverity` so that direct access to a private key
> file isn't necessary to sign files.

Sorry, I didn't notice that you had already sent out a new version of this
patch.  Is this version intended to address all my comments?  Some of the
comments I made don't seem to have been fully addressed.

- Eric
