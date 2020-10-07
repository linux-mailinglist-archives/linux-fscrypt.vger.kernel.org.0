Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58B02869C5
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Oct 2020 23:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgJGVAn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Oct 2020 17:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgJGVAm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Oct 2020 17:00:42 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F1C120782;
        Wed,  7 Oct 2020 21:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602104442;
        bh=GWys9lwjFwn3y2WLSz7/9gklVnm2rLZvAo9opNCFNxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wsIcdJkx02/Jqxk4lgxxNghmKWKmf7nGpPUem6SwFDSBheWQD2Hi1eC7x3BHLBFxf
         ei/Is0gGRbQ4qXTA7QMZXG5EhehNR+eiAStKtP0JMC1lR6Hdz9O3poFMWmF42JxCWl
         O1fI67OYgM3d+jCQ6RDECZAN1PTZ/wiBPZopnKSA=
Date:   Wed, 7 Oct 2020 14:00:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/3] add support for metadata encryption to F2FS
Message-ID: <20201007210040.GB1530638@gmail.com>
References: <20201005073606.1949772-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005073606.1949772-1-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 05, 2020 at 07:36:03AM +0000, Satya Tangirala wrote:
> This patch series adds support for metadata encryption to F2FS using
> blk-crypto.

This patch series needs more explanation about what "metadata encryption" is,
why people will want to use it (as opposed to either not using it, or using
fscrypt + dm-crypt instead), and why this is the best implementation of it.

> Patch 2 introduces some functions to fscrypt that help filesystems perform
> metadata encryption. Any filesystem that wants to use metadata encryption
> can call fscrypt_setup_metadata_encryption() with the super_block of the
> filesystem, the encryption algorithm and the descriptor of the encryption
> key. The descriptor is looked up in the logon keyring of the current
> session with "fscrypt:" as the prefix of the descriptor.

I notice this is missing the step I suggested to include the metadata encryption
key in the HKDF application-specific info string when deriving subkeys from the
fscrypt master keys.

The same effect could also be achieved by adding an additional level to the key
hierarchy: each HKDF key would be derived from a fscrypt master key and the
metadata encryption key.

We need one of those, to guarantee that the file contents encryption is at least
as strong as the "metadata encryption".

- Eric
