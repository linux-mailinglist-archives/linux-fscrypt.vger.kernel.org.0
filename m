Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9F72273D0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Jul 2020 02:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGUAck (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Jul 2020 20:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgGUAcj (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Jul 2020 20:32:39 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688A4207FC
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Jul 2020 00:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595291559;
        bh=w0V0whFKvVrMSObOMe9hv/04GwtTn9eUrgtjB6VduMI=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=UzQ02+wHJGlyT/8t5by3t6j/nNfWXGb90sO/QpANpQarmeSqJtN+vUgXA1ZOqleGH
         ZnPdFcNz6DxEntHRml4MaQtgbZVX/B9toddfPJYgrLFuBMEgE7YFKQibmEsHGceaYf
         I1mTfopHR4Q8cf+dQ0KVSnxIVEsc4KV2ub2NzcpA=
Date:   Mon, 20 Jul 2020 17:32:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: rename FS_KEY_DERIVATION_NONCE_SIZE
Message-ID: <20200721003238.GB7464@sol.localdomain>
References: <20200708215722.147154-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708215722.147154-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 08, 2020 at 02:57:22PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The name "FS_KEY_DERIVATION_NONCE_SIZE" is a bit outdated since due to
> the addition of FSCRYPT_POLICY_FLAG_DIRECT_KEY, the file nonce may now
> be used as a tweak instead of for key derivation.  Also, we're now
> prefixing the fscrypt constants with "FSCRYPT_" instead of "FS_".
> 
> Therefore, rename this constant to FSCRYPT_FILE_NONCE_SIZE.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to fscrypt.git#master for 5.9.
