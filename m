Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 145A55B75F
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jul 2019 10:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfGAI7z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 1 Jul 2019 04:59:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50771 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728220AbfGAI7z (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 1 Jul 2019 04:59:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id n9so3087200wmi.0;
        Mon, 01 Jul 2019 01:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w61ODbvkI0Zrw3EYxOf1VfxblVTs7Fwinzs4mF4Uw28=;
        b=dgvfmzPiBGjYavETfH1aqOg3TgAJMNmg3yENDIayIfGIrNEAbCCpjzOEXYJQjulb4/
         Fl0Dx5Q5MPg3IMUNN79TmVblHeswOa0YrCw8Zn6Nf1r2mMzOGCsa1m0nXVjnxcjY8Tfo
         zJFTPeju8KBM3BtrWtwmlc5+bS36CehftgWDjYHmNy5yNdDDqfqhWgaanbvsjN83wtj2
         SwKhJ6XEQf+b+fRZeVTMGujH3grDIgBlvu2UBlUnHNccdMRwemuSGQti04Be1zNW6JVS
         6HQaq7mxIoCcxhgjnyDFmECj34cWIyUhgTHzmnN7z/+LVjtWuTwV47A0DEcQc7FYiTVe
         Or1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w61ODbvkI0Zrw3EYxOf1VfxblVTs7Fwinzs4mF4Uw28=;
        b=LpgXqto/MuAAbGaMKprMSN5ELzLnNaSwPX4cyUinyNrjBPaJ+Qln7eIby02gWQ/a+X
         ggYbfaB2NgJXBJ60DQ1jpStpf07Fuphx23KXGBxSHUck5lMSGg5Ux4j+2zD/ctfFGQCR
         z7WN3fmi5Pe4A0ml9v/6LA+JaaFq7WlIbG1dKefCEfSWoygSraCALwnIGbuM0f5jmC0B
         9vUE7c/vrodZ+gT2FaPHYsiU+73Gf8JFXz2zkT0GZJ8wazKBS9Iq+trtgm+4TG0eierB
         s86KOy0ulMijI4ouI115pw1fN2kBw2g9vQzTZj/OlWRu7l1DPt63DkA3FI5LmS6xx7m/
         akCA==
X-Gm-Message-State: APjAAAVTmGwP+yd6y/EmT8+mQmpRZJZTeY3Kik1JHmG86pbl8Oevo4BM
        3mt72NiajNGr0fqHa3+hmAc=
X-Google-Smtp-Source: APXvYqxrdqHGK9w8pJlZpIcrlORI9AX1/geKS8zqY+DV00b239EBSoZEjEHk6Kkaoy3lOnz8HytdJA==
X-Received: by 2002:a05:600c:2182:: with SMTP id e2mr16175249wme.104.1561971593030;
        Mon, 01 Jul 2019 01:59:53 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id r16sm18499171wrr.42.2019.07.01.01.59.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 01:59:52 -0700 (PDT)
Subject: Re: [PATCH v6 4/7] md: dm-crypt: switch to ESSIV crypto API template
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
 <20190628152112.914-5-ard.biesheuvel@linaro.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f068888f-1a13-babf-0144-07939a79d9d9@gmail.com>
Date:   Mon, 1 Jul 2019 10:59:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628152112.914-5-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 28/06/2019 17:21, Ard Biesheuvel wrote:
> Replace the explicit ESSIV handling in the dm-crypt driver with calls
> into the crypto API, which now possesses the capability to perform
> this processing within the crypto subsystem.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

>  drivers/md/dm-crypt.c | 200 ++++----------------

...

> -/* Wipe salt and reset key derived from volume key */
> -static int crypt_iv_essiv_wipe(struct crypt_config *cc)

Do I understand it correctly, that this is now called inside the whole cipher
set key in wipe command (in crypt_wipe_key())?

(Wipe message is meant to suspend the device and wipe all key material
from memory without actually destroying the device.)

> -{
> -	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
> -	unsigned salt_size = crypto_shash_digestsize(essiv->hash_tfm);
> -	struct crypto_cipher *essiv_tfm;
> -	int r, err = 0;
> -
> -	memset(essiv->salt, 0, salt_size);
> -
> -	essiv_tfm = cc->iv_private;
> -	r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
> -	if (r)
> -		err = r;
> -
> -	return err;
> -}

...

> @@ -2435,9 +2281,19 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
>  	}
>  
>  	ret = crypt_ctr_blkdev_cipher(cc, cipher_api);
> -	if (ret < 0) {
> -		ti->error = "Cannot allocate cipher string";
> -		return -ENOMEM;
> +	if (ret < 0)
> +		goto bad_mem;
> +
> +	if (*ivmode && !strcmp(*ivmode, "essiv")) {
> +		if (!*ivopts) {
> +			ti->error = "Digest algorithm missing for ESSIV mode";
> +			return -EINVAL;
> +		}
> +		ret = snprintf(buf, CRYPTO_MAX_ALG_NAME, "essiv(%s,%s,%s)",
> +			       cipher_api, cc->cipher, *ivopts);
> +		if (ret < 0 || ret >= CRYPTO_MAX_ALG_NAME)
> +			goto bad_mem;

Hm, nitpicking, but goto from only one place while we have another -ENOMEM above...

Just place this here without goto?

> +	ti->error = "Cannot allocate cipher string";
> +	return -ENOMEM;

Otherwise

Reviewed-by: Milan Broz <gmazyland@gmail.com>

Thanks,
Milan
